//
//  NewWifiManager.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 25/02/21.
//  Copyright © 2021 VitandreaCorporation. All rights reserved.
//

import Foundation
import SwiftSocket
import os

/**
Class that manage the connection with the server. It allows to connect, disconnect, send and receive message with the server.
It is used as a singletone with the attribute "sharedInstance".
 */
public class WIFIModuleConnectionManager : TCPClient{
    
    /**
     Singleton for the class WIFIModuleConnectionManager
     */
    public static let sharedInstance = WIFIModuleConnectionManager(address: wifiModuleSocket.address, port: wifiModuleSocket.port)
    private var connectionCheckerTimer : Timer!
    private var setupConfiguration : SetupConfiguration = SetupConfiguration()
    public var delegate : WIFIModuleConnectionManagerDelegate?
    var timeSpentInSetup = 0
    let MAX_TIME_SETUP = 5
    private var logger = Logger()
    
    
    private var isSetupDone : Bool {
        get{
            return setupConfiguration.isComplete()
        }
    }
    private(set) var connectionStatus : ConnectionStatus = .disconnected {
        didSet {
            switch connectionStatus {
            case .connected:
                logger.info("Connection Enstablished!")
                if let delegate = self.delegate{
                    delegate.WIFIModuleConnectionStatusChanged(actualConnectionStatus: .connected)
                }
            case .disconnected:
                logger.info("Connetion lose!")
                self.close()
                setupConfiguration.reset()
                timeSpentInSetup = 0
                if let delegate = self.delegate{
                    delegate.WIFIModuleConnectionStatusChanged(actualConnectionStatus: .disconnected)
                }
                connectionCheckerTimer.fire()
                
            case .setup:
                logger.info("Entering in setup mode.")
                if let delegate = self.delegate{
                    delegate.WIFIModuleConnectionStatusChanged(actualConnectionStatus: .setup)
                    delegate.onStartSetup()
                }
                self.setup()
            }
        }
    }
    

    
    
    
    
    override private init(address : String, port : Int32) {
        super.init(address: address, port: port)
        
        //Starting the connection loop
        connectionCheckerTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: connectionTimerLoop(timer:))
        connectionCheckerTimer.fire()
        
    }
    
    
    /**
     Method used in the Timer to execute the connention to the remote Server
     
     Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: connectionTimerLoop(timer:))
     
     - Parameter timer: Object of class Timer who is calling the method
     */
    private func connectionTimerLoop(timer : Timer){
        switch self.connectionStatus{
            case .disconnected:
                self.enstablishConnection()
            case .connected:
                if sendCheckConnectionCommand(){
                    logger.info("Connection is still UP.")
                }else{
                    logger.info("Connection is DOWN.")
                }
            case .setup:
                timeSpentInSetup += Int(timer.timeInterval)
                
                if timeSpentInSetup >= MAX_TIME_SETUP{
                    connectionStatus = .disconnected
                }
        }
    }
    
    /**
     Method used to connect to the Server with a timeout of 2 seconds.
     
     - Warning: The code is executed asynchronously
     */
    private func enstablishConnection(){
        
        //Asyncronous task to enstablish the connection due to the timeout
        DispatchQueue.global().async {
            
            //Checking the result of the connection attempt
            switch self.connect(timeout: 2){
            case .success:
                //After succesfull connection, the setup procedure starts.
                self.connectionStatus = .setup
            case .failure(_):
                self.logger.error("Error during connection to server.")
                self.connectionStatus = .disconnected
                
            }
        }
    }
    
    private func readFromConnection() -> [String] {
        
        var allCommandReceived : [String] = []
        
        if let data = self.read(1024 * MaxCommandLength, timeout: 4){
            if let response = String(bytes: data, encoding: .utf8) {
                
                if response.count < 10 { return [] }
                
                for i in 0...(Int(response.count / 10) - 1) {
                    let start = response.index(response.startIndex, offsetBy: i*10)
                    let end = response.index(start, offsetBy: 10)
                    
                    var recvCommand = String(response[start..<end])
                    let newStart = recvCommand.index(recvCommand.startIndex, offsetBy: 0)
                    let newEnd = recvCommand.index(newStart, offsetBy: 6)
                    print("Command received: \(recvCommand)")

                    recvCommand = String(recvCommand[newStart..<newEnd])
                    
                    for c in recvCommand{
                        if !c.isLetter{
                            continue
                        }
                    }
                    allCommandReceived.append(String(response[start..<end]))
                }
            }
        }
        
        return allCommandReceived
    }
    
    private func sendMessage(_ command : String) -> Bool{
        switch self.send(string: command){
        case .success:
            return true
        case .failure(_):
            //Excecute the disconnection procedure
            return false
        }
    }
    
    private func completeButtonIndex(remoteButton button : RemoteButtonIndex, withOPCode opCode: NormalStatusOPCode, offset : Int = 0) -> String{
        let stringIndex = "\(button)"
        var finalString = ""
        
        for _ in 0..<(MaxCommandLength - stringIndex.count - opCode.rawValue.count - offset){
            finalString += "0"
        }
        finalString += stringIndex
        
        return finalString
    }
    
    private func completeLastDigit(stringToComplete string : String, maximumStringLength maxLength : Int) -> String{
        var finalString = string
        for _ in 1...(maxLength - string.count){ finalString += "0" }
        return finalString
    }
    
    public func fireTimer(){
        connectionCheckerTimer.fire()
    }
    
}


//Extension with all the method for the setup
extension WIFIModuleConnectionManager{
    
    private func setup(){
        repeat {
            //Receiving all the SETUP command
            let setupCommandsReceived = self.readFromConnection()
            
            print(setupCommandsReceived)
            
            //Check the setup message received and filling the setup configurator
            let missingConfiguration = self.setupConfiguration.fillUpConfiguration(setupCommandsReceived: setupCommandsReceived)
            
            //Sending the missing setup configuration
            self.sendMissingConfigurationCommand(missingConfiguration)
        } while !self.isSetupDone
        
        //Setup ended
        //Do all the operation after the setup is ended
        
        //Sending the message for the ending of the setup procedure
        let endSetupCommand = self.completeLastDigit(stringToComplete: SetupStatusOPCode.ENDSETUP.rawValue, maximumStringLength: MaxCommandLength)
        if self.sendMessage(endSetupCommand){
            logger.info("Command sent: \(endSetupCommand)")
            if let delegate = self.delegate {
                delegate.onEndSetup()
            }
            self.connectionStatus = .connected
        }else{
            logger.error("Error sending the command: \(endSetupCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    private func sendMissingConfigurationCommand(_ missingConfiguration : [String]){
        
        for conf in missingConfiguration{
            let finalCommand = SetupStatusOPCode.NOTRECEIVED.rawValue + truncateCommandForSetup(conf)
            
            //Sending the not received message with the detail of what is missing
            if sendMessage(finalCommand){
                logger.info("Command sent: \(finalCommand)")
            }else{
                logger.error("Error sending the command: \(finalCommand)")
                self.connectionStatus = .disconnected
            }
        }
    }
    
    private func truncateCommandForSetup(_ command : String) -> String{
        let startIndex = command.index(command.startIndex, offsetBy: 0)
        let endIndex = command.index(command.startIndex, offsetBy: 4)
        
        return String(command[startIndex..<endIndex])
    }
    
}




extension WIFIModuleConnectionManager{
    public func sendSelectedSection() {
        var finalCommand = NormalStatusOPCode.SECTION.rawValue
        finalCommand += BedroomSelectedSections[0] == true ? "1" : "0"
        finalCommand += BedroomSelectedSections[1] == true ? "1" : "0"
        finalCommand += BedroomSelectedSections[2] == true ? "1" : "0"
        finalCommand += BedroomSelectedSections[3] == true ? "1" : "0"
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    public func sendButtonCommand(remoteButton button : RemoteButtonIndex){
        let finalCommand = NormalStatusOPCode.BUTTON.rawValue + completeButtonIndex(remoteButton: button, withOPCode: NormalStatusOPCode.BUTTON)
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    public func sendWButtonCommand() {
        let finalCommand = NormalStatusOPCode.WALLBUTTON.rawValue + (isWallButtonEnabled ? "1111" : "0000")
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    public func sendSingleClickWallButtonCommand(){
        let finalCommand = NormalStatusOPCode.FIRSTCLICKWALLBUTTON.rawValue + (isSingleClickWallEnabled ? "11" : "00") + "\(completeButtonIndex(remoteButton: singleClickWallButtonID , withOPCode: NormalStatusOPCode.FIRSTCLICKWALLBUTTON, offset:2))"
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    public func sendLongPressionWallButtonCommand(){
        let finalCommand = NormalStatusOPCode.LONGPRESSIONBUTTON.rawValue + (isLongClickWallEnabled ? "11" : "00") + "\(completeButtonIndex(remoteButton: longClickWallButtonID , withOPCode: NormalStatusOPCode.LONGPRESSIONBUTTON, offset:2))"
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    public func sendMovementSensorCommand(){
        var finalCommand = NormalStatusOPCode.MOVEMENTSENSOR.rawValue
        
        switch movementSensorStatus{
        case .ENABLED:
            finalCommand += "11"
        case .DISABLED:
            finalCommand += "00"
        case .AUTO:
            finalCommand += "22"
        }
        
        finalCommand += "\(completeButtonIndex(remoteButton: movementSensorClickButtonID , withOPCode: NormalStatusOPCode.MOVEMENTSENSOR, offset:2))"
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    public func sendStairCommand(withDirection direction : StairDirection, withRotationSpeed rotationSpeed : Int){
        let finalCommand = NormalStatusOPCode.STAIR.rawValue + direction.rawValue + String(repeating: "0",count: 3-String(rotationSpeed).count) + String(rotationSpeed)
        print("Sending command: \(finalCommand)")
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
        }
    }
    
    public func sendCheckConnectionCommand() -> Bool{
        let finalCommand = SetupStatusOPCode.CHECKCONNECTION.rawValue
        
        if sendMessage(finalCommand){
            logger.info("Command sent: \(finalCommand)")
            return true
        }else{
            logger.error("Error sending the command: \(finalCommand)")
            self.connectionStatus = .disconnected
            return false
        }
    }
}


private class SetupConfiguration {
    private var section = false
    private var wallButton = false
    private var firstClickWallButton = false
    private var longPressionWallButton = false
    private var movementSensor = false
    private var logger = Logger()
    
    func reset(){
        section = false
        wallButton = false
        firstClickWallButton = false
        longPressionWallButton = false
        movementSensor = false
    }
    
    func isComplete() -> Bool{
        return section && wallButton && firstClickWallButton && longPressionWallButton && movementSensor
    }
    
    func fillUpConfiguration(setupCommandsReceived setupCommands : [String]) -> [String] {
        
        var returnValue : [String] = []
        
        for command in setupCommands{
            let endIndex = command.index(command.startIndex, offsetBy: 6)
            let realCommand = String(command[..<endIndex])
            let payload = String(command[endIndex...])
            
            switch realCommand {
            case SetupConfigurationOPCode.SECTION.rawValue:
                
                //Attempting to update the shared instance
                logger.log("SECTION Setup command received with payload: \(payload)")
                if updateBedroomSelectedSections(payload: payload){
                    //Setting the flag
                    self.section = true
                }else{
                    returnValue.append(SetupConfigurationOPCode.SECTION.rawValue)
                }
                
            case SetupConfigurationOPCode.FIRSTCLICKWALLBUTTON.rawValue:
                logger.log("FIRSTCLICKWALLBUTTON Setup command received with payload: \(payload)")
                if updateFirstClickWallButton(payload: payload){
                    firstClickWallButton = true
                }else{
                    returnValue.append(SetupConfigurationOPCode.FIRSTCLICKWALLBUTTON.rawValue)
                }
                
            case SetupConfigurationOPCode.LONGPRESSIONBUTTON.rawValue:
                logger.log("LONGPRESSIONBUTTON Setup command received with payload \(payload)")
                if updateLongPressionWallButton(payload: payload){
                    longPressionWallButton = true
                }else{
                    returnValue.append(SetupConfigurationOPCode.LONGPRESSIONBUTTON.rawValue)
                }
                
            case SetupConfigurationOPCode.WALLBUTTON.rawValue:
                logger.log("WALLBUTTON Setup command received with payload \(payload)")
                if updateWallButtonStatus(payload: payload){
                    wallButton = true
                }else{
                    returnValue.append(SetupConfigurationOPCode.WALLBUTTON.rawValue)
                }
            case SetupConfigurationOPCode.MOVEMENTSENSOR.rawValue:
                logger.log("MOVEMENTSENSOR Setup command received with payload \(payload)")
                if updateMovementSensor(payload: payload){
                    movementSensor = true
                }else{
                    returnValue.append(SetupConfigurationOPCode.MOVEMENTSENSOR.rawValue)
                }
               
            default:
                logger.critical("Wrong SETUP payload. \(payload)")
            }
        }
        
        return returnValue
    }
    
    private func updateLongPressionWallButton(payload newPayload : String ) -> Bool{
        guard newPayload.count == 4 else { return false }
        
        //Extrapolating the status of the long pression from the payload
        let enabled = String(newPayload[..<newPayload.index(newPayload.startIndex, offsetBy: 2)])
        
        //Extrapolating the button code from the payload
        let buttonID = String(newPayload[newPayload.index(newPayload.startIndex, offsetBy: 2)..<newPayload.endIndex])
        
        //Trying  to cast the buttonID from the payload into a INT
        guard let remoteButtonIndex = Int(buttonID) else { return false }
        
        //Checking if the remote button code in the payload is a real and correct code associated to a remote button
        guard let _ = REMOTE_BUTTON[remoteButtonIndex + 1] else { return false }
        
        //Setting the payload value into the shared instances
        isLongClickWallEnabled = enabled == "11" ? true : false
        longClickWallButtonID = remoteButtonIndex + 1
                
        return true
    }
    
    private func updateFirstClickWallButton(payload newPayload : String ) -> Bool{
        guard newPayload.count == 4 else { return false }
        
        //Extrapolating the status of the single click from the payload
        let enabled = String(newPayload[..<newPayload.index(newPayload.startIndex, offsetBy: 2)])
        
        //Extrapolating the button code from the payload
        let buttonID = String(newPayload[newPayload.index(newPayload.startIndex, offsetBy: 2)..<newPayload.endIndex])
        
        //Trying  to cast the buttonID from the payload into a INT
        guard let remoteButtonIndex = Int(buttonID) else { return false }
        
        //Checking if the remote button code in the payload is a real and correct code associated to a remote button
        guard let _ = REMOTE_BUTTON[remoteButtonIndex + 1] else { return false }
        
        //Setting the payload value into the shared instances
        isSingleClickWallEnabled = enabled == "11" ? true : false
        singleClickWallButtonID =  remoteButtonIndex + 1
                
        return true
    }
    
    private func updateWallButtonStatus(payload newPayload : String ) -> Bool{
        guard newPayload.count == 4 else { return false }   //If the lenght of the payload is different from 4 means that the payload is incorrent
        
        if newPayload == "1111"{
            isWallButtonEnabled = true
        }else { isWallButtonEnabled = false }
        
        return true
    }
    
    private func updateBedroomSelectedSections(payload newPayload : String) -> Bool{
        guard newPayload.count == 4 else { return false }   //If the lenght of the payload is different from 4 means that the payload is incorrent
        
        //Iterating among the section
        for section in 0..<4 {
            BedroomSelectedSections[section] = ( newPayload[newPayload.index(newPayload.startIndex, offsetBy: section)] == "1" ? true : false )
        }
        return true
    }
    
    private func updateMovementSensor(payload newPayload : String) -> Bool {
        guard newPayload.count == 4 else { return false }   //If the lenght of the payload is different from 4 means that the payload is incorrent

        //Extrapolating the status of the single click from the payload
        let enabled = String(newPayload[..<newPayload.index(newPayload.startIndex, offsetBy: 2)])
        
        //Extrapolating the button code from the payload
        let buttonID = String(newPayload[newPayload.index(newPayload.startIndex, offsetBy: 2)..<newPayload.endIndex])
        
        //Trying  to cast the buttonID from the payload into a INT
        guard let remoteButtonIndex = Int(buttonID) else { return false }
        
        //Checking if the remote button code in the payload is a real and correct code associated to a remote button
        guard let _ = REMOTE_BUTTON[remoteButtonIndex + 1] else { return false }
        
        switch enabled{
            case "11":
                movementSensorStatus = .ENABLED
            case "00":
                movementSensorStatus = .DISABLED
            case "22":
                movementSensorStatus = .AUTO
            default:
                print("Payload not valid");
        }
        
        movementSensorClickButtonID = remoteButtonIndex + 1
        
        return true
    }
}


public enum ConnectionStatus {
    case connected
    case disconnected
    case setup
}


public protocol WIFIModuleConnectionManagerDelegate {
    func WIFIModuleConnectionStatusChanged(actualConnectionStatus status : ConnectionStatus)
    func onStartSetup()
    func onEndSetup()
}



