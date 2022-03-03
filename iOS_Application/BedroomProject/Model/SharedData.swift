//
//  SharedData.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 23/08/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation

public enum ColorTheme{
    case Dark
    case Light
}

public enum StairDirection : String{
    case Forwards = "1"
    case Backwards = "0"
}

public enum MovementSensorStatus : Int{
    case ENABLED = 0
    case DISABLED = 1
    case AUTO = 2
}

var appColorTheme : ColorTheme = .Dark




//SERVER STATUS VARIABLES RECEIVED FROM THE SETUP PROCEDURE
var BedroomSelectedSections : [Int : Bool] = [0:true,1:true,2:true,3:true]

var singleClickWallButtonID : Int = 6
var longClickWallButtonID : Int = 6
var movementSensorClickButtonID : Int = 6

var isWallButtonEnabled = true

var isSingleClickWallEnabled = true
var isLongClickWallEnabled = true
var movementSensorStatus : MovementSensorStatus = .DISABLED



