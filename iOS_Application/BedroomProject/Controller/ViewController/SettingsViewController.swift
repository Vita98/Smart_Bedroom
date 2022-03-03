//
//  SettingsViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 08/09/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

class SettingsViewController: SuperViewController {

    @IBOutlet weak var wallButtonLabel: UILabel!
    @IBOutlet weak var enabledLabel: UILabel!
    @IBOutlet weak var singleClickLabel: UILabel!
    @IBOutlet weak var longClickLabel: UILabel!
    @IBOutlet weak var stairLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var shareBackgroundLabel: UILabel!
    @IBOutlet weak var downloadRandomBackgroundLabel: UILabel!
    //@IBOutlet weak var movementSensorEnabledLabel: UILabel! //
    @IBOutlet weak var movementSensorLabel: UILabel!
    
    @IBOutlet weak var singleClickComponentContainer: UIView!
    @IBOutlet weak var longClickComponentContainer: UIView!
    @IBOutlet weak var stairComponentContainer: UIView!
    @IBOutlet weak var movementSensorClickComponentContainer: UIView!
    
    @IBOutlet weak var singleClickSwitch: UISwitch!
    @IBOutlet weak var longClickSwitch: UISwitch!
    @IBOutlet weak var generalEnablerSwitch: UISwitch!
    @IBOutlet weak var randomBakgroundSwitch: UISwitch!
    @IBOutlet weak var movementSensorSegmentedControl: UISegmentedControl!
    //@IBOutlet weak var movementSensorClickSwitch: UISwitch! //
    
    private var customElasticSlider : UIElasticSlider?
    
    private var singleClickCollectionViewController : ClickSelectionCollectionViewController!
    private var longClickCollectionViewController : ClickSelectionCollectionViewController!
    private var movementSensorClickCollectionViewController : ClickSelectionCollectionViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setBackgroundView()

        // Do any additional setup after loading the view.
        configureClickSection()
        configureElesticSlider()
        configureSensorSection()
        
        //Configuring the random background switch
        randomBakgroundSwitch.isOn = SettingsManager.sharedInstance.randomBackgroundProperty
        
        setInitialStatusValues()
        
        if appColorTheme == .Dark{ setDarkTheme() }
        else { setLightTheme() }
        
        singleClickCollectionViewController.delegate = self
        longClickCollectionViewController.delegate = self
        movementSensorClickCollectionViewController.delegate = self
        
        //Notification observer for the theme color change
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkTheme), name: lightThemeSelectedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightTheme), name: darkThemeSelectedNotificationName, object: nil)
        
        //Notification observer for the completed setup action
        NotificationCenter.default.addObserver(self, selector: #selector(setupCompletedActions), name: setupCompletedNotificationName, object: nil)
    }
    
    private func configureSensorSection(){
        
        //Configuring the collection view for the movement sensor
        movementSensorClickCollectionViewController = ClickSelectionCollectionViewController(withIndexButtonSelected: movementSensorClickButtonID, withContainer: movementSensorClickComponentContainer)
        
        movementSensorClickComponentContainer.insertSubview(movementSensorClickCollectionViewController.collectionView, belowSubview: movementSensorSegmentedControl)
        
        movementSensorClickCollectionViewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
        movementSensorClickCollectionViewController.collectionView.topAnchor.constraint(equalTo: movementSensorSegmentedControl.bottomAnchor, constant: 5).isActive = true
        movementSensorClickCollectionViewController.collectionView.leadingAnchor.constraint(equalTo: movementSensorClickComponentContainer.leadingAnchor, constant: 0).isActive = true
        movementSensorClickCollectionViewController.collectionView.trailingAnchor.constraint(equalTo: movementSensorClickComponentContainer.trailingAnchor, constant: 0).isActive = true
        movementSensorClickCollectionViewController.collectionView.bottomAnchor.constraint(equalTo: movementSensorClickComponentContainer.bottomAnchor, constant: -5).isActive = true
        
        movementSensorSegmentedControl.layer.borderWidth = 0.5
        movementSensorSegmentedControl.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.38)
    }
    
    private func configureClickSection(){
        
        //Configuring the first collection view for the single click
        singleClickCollectionViewController = ClickSelectionCollectionViewController(withIndexButtonSelected: singleClickWallButtonID,withContainer: singleClickComponentContainer, withSwitchController: singleClickSwitch)
        
        singleClickComponentContainer.insertSubview(singleClickCollectionViewController.collectionView, belowSubview: singleClickSwitch)
        
        singleClickCollectionViewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
        singleClickCollectionViewController.collectionView.topAnchor.constraint(equalTo: singleClickLabel.bottomAnchor, constant: 5).isActive = true
        singleClickCollectionViewController.collectionView.leadingAnchor.constraint(equalTo: singleClickComponentContainer.leadingAnchor, constant: 0).isActive = true
        singleClickCollectionViewController.collectionView.trailingAnchor.constraint(equalTo: singleClickComponentContainer.trailingAnchor, constant: 0).isActive = true
        singleClickCollectionViewController.collectionView.bottomAnchor.constraint(equalTo: singleClickComponentContainer.bottomAnchor, constant: -5).isActive = true
        
        //Configuring the second collection view for the long click
        longClickCollectionViewController = ClickSelectionCollectionViewController(withIndexButtonSelected: longClickWallButtonID,withContainer: longClickComponentContainer, withSwitchController: longClickSwitch)
        
        longClickComponentContainer.insertSubview(longClickCollectionViewController.collectionView, belowSubview: longClickSwitch)
        
        longClickCollectionViewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
        longClickCollectionViewController.collectionView.topAnchor.constraint(equalTo: longClickSwitch.bottomAnchor, constant: 5).isActive = true
        longClickCollectionViewController.collectionView.leadingAnchor.constraint(equalTo: longClickComponentContainer.leadingAnchor, constant: 0).isActive = true
        longClickCollectionViewController.collectionView.trailingAnchor.constraint(equalTo: longClickComponentContainer.trailingAnchor, constant: 0).isActive = true
        longClickCollectionViewController.collectionView.bottomAnchor.constraint(equalTo: longClickComponentContainer.bottomAnchor, constant: -5).isActive = true
        
    }
    
    private func configureElesticSlider(){
        let slider = UIElasticSlider(frame: stairComponentContainer.frame)
        
        stairComponentContainer.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.widthAnchor.constraint(equalToConstant: stairComponentContainer.frame.width).isActive = true
        slider.heightAnchor.constraint(equalToConstant: stairComponentContainer.frame.height).isActive = true
        slider.centerXAnchor.constraint(equalTo: stairComponentContainer.centerXAnchor, constant: 0).isActive = true
        slider.centerYAnchor.constraint(equalTo: stairComponentContainer.centerYAnchor, constant: 0).isActive = true
        slider.delegate = self
        
        customElasticSlider = slider
    }
    
    private func setInitialStatusValues(){
        
        //Executing the animation in the main thread
        DispatchQueue.main.async {
            //Setting the single click object to the shared data from the setup configuration
            if !isSingleClickWallEnabled{
                self.singleClickSwitch.setOn(false, animated: true)
                self.singleClickCollectionViewController.disableCollectionView(animation: true)
            }
            
            if !isLongClickWallEnabled{
                self.longClickSwitch.setOn(false, animated: true)
                self.longClickCollectionViewController.disableCollectionView(animation: true)
            }
            
            if !isWallButtonEnabled{
                self.generalEnablerSwitch.setOn(false, animated: true)
                self.singleClickCollectionViewController.disableAllContainer(animation: true)
                self.longClickCollectionViewController.disableAllContainer(animation: true)
            }
            
            //Movement sensor
            self.movementSensorSegmentedControl.selectedSegmentIndex = movementSensorStatus.rawValue
            self.movementSensorSegmentControlValueChanged(self.movementSensorSegmentedControl as Any)
        }
        
    }
    
    @IBAction func movementSensorSegmentControlValueChanged(_ sender: Any) {
        switch movementSensorSegmentedControl.selectedSegmentIndex{
        case MovementSensorStatus.ENABLED.rawValue:
            movementSensorStatus = .ENABLED
            movementSensorClickCollectionViewController.enableCollectionView(animation: true)
        case MovementSensorStatus.DISABLED.rawValue:
            movementSensorStatus = .DISABLED
            movementSensorClickCollectionViewController.disableCollectionView(animation: true)
        case MovementSensorStatus.AUTO.rawValue:
            movementSensorStatus = .AUTO
            movementSensorClickCollectionViewController.enableCollectionView(animation: true)
        default:
            print("Movement Sensor Status not valid");
        }
        WIFIModuleConnectionManager.sharedInstance.sendMovementSensorCommand()
    }
    
    @IBAction func generalEnablerSwitchValueChanged(_ sender: Any) {
        
        if generalEnablerSwitch.isOn{
            singleClickCollectionViewController.enableAllContainer(animation: true)
            longClickCollectionViewController.enableAllContainer(animation: true)
            
            isWallButtonEnabled = true
            WIFIModuleConnectionManager.sharedInstance.sendWButtonCommand()
        }else{
            singleClickCollectionViewController.disableAllContainer(animation: true)
            longClickCollectionViewController.disableAllContainer(animation: true)
            
            isWallButtonEnabled = false
            WIFIModuleConnectionManager.sharedInstance.sendWButtonCommand()
        }
    }
    
    @IBAction func ClickShareBackground(_ sender: Any) {
        let image = SettingsManager.sharedInstance.backgroundImage
        if let img = image{
            let vc = UIActivityViewController(activityItems: [img], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    @IBAction func ClickSwitchRandomBackground(_ sender: Any) {
        if randomBakgroundSwitch.isOn{
            SettingsManager.sharedInstance.randomBackgroundProperty = true
        }else {
            SettingsManager.sharedInstance.randomBackgroundProperty = false
        }
        
    }
}

extension SettingsViewController : ThemeDelegate {
    func setDarkTheme() {
        wallButtonLabel.textColor = .black
        enabledLabel.textColor = .black
        stairLabel.textColor = .black
        singleClickLabel.textColor = .black
        longClickLabel.textColor = .black
        shareBackgroundLabel.textColor = .black
        backgroundLabel.textColor = .black
        downloadRandomBackgroundLabel.textColor = .black
        //movementSensorEnabledLabel.textColor = .black
        movementSensorLabel.textColor = .black
        if let slider = customElasticSlider { slider.changeColorTheme(with: .Dark)}
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        movementSensorSegmentedControl.selectedSegmentTintColor = UIColor.white
        movementSensorSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:.normal)
        movementSensorSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:.selected)
    }
    
    func setLightTheme() {
        wallButtonLabel.textColor = .white
        enabledLabel.textColor = .white
        stairLabel.textColor = .white
        singleClickLabel.textColor = .white
        longClickLabel.textColor = .white
        shareBackgroundLabel.textColor = .white
        backgroundLabel.textColor = .white
        downloadRandomBackgroundLabel.textColor = .white
        //movementSensorEnabledLabel.textColor = .white
        movementSensorLabel.textColor = .white
        if let slider = customElasticSlider { slider.changeColorTheme(with: .Light)}
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        movementSensorSegmentedControl.selectedSegmentTintColor = UIColor.white
        movementSensorSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for:.normal)
        movementSensorSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:.selected)
    }
}

extension SettingsViewController {
    
    //Function called when the setup is finished
    @objc private func setupCompletedActions(){
        
        //Enable or disable the collection view based on the received status from the setup
        setInitialStatusValues()
        
        //Scrolling the collections view on the new selected item
        singleClickCollectionViewController.scrollCollectionView(toButton: singleClickWallButtonID, animated: true)
        longClickCollectionViewController.scrollCollectionView(toButton: longClickWallButtonID, animated: true)
        movementSensorClickCollectionViewController.scrollCollectionView(toButton: movementSensorClickButtonID, animated: true)
    }
}

extension SettingsViewController : ClickSelectionCollectionViewDelegate {
    func switchStatusChanged(_ status: Bool, _ container: UIView) {
        switch container {
        case singleClickComponentContainer:
            isSingleClickWallEnabled = status
            WIFIModuleConnectionManager.sharedInstance.sendSingleClickWallButtonCommand()
        case longClickComponentContainer:
            isLongClickWallEnabled = status
            WIFIModuleConnectionManager.sharedInstance.sendLongPressionWallButtonCommand()
        default:
            print("Container not present in this controller.")
        }
    }
    
    func buttonSelected(_ button: RemoteButtonIndex, _ container: UIView) {
        switch container {
        case singleClickComponentContainer:
            singleClickWallButtonID = button
            WIFIModuleConnectionManager.sharedInstance.sendSingleClickWallButtonCommand()
        case longClickComponentContainer:
            longClickWallButtonID = button
            WIFIModuleConnectionManager.sharedInstance.sendLongPressionWallButtonCommand()
        case movementSensorClickComponentContainer:
            movementSensorClickButtonID = button
            WIFIModuleConnectionManager.sharedInstance.sendMovementSensorCommand()
        default:
            print("Container not recognized!")
        }
    }
}

extension SettingsViewController : UiElasticSliderDelegate {
    func statusChanged(_ direction: StairDirection, _ rotationSpeed: Int) {
        WIFIModuleConnectionManager.sharedInstance.sendStairCommand(withDirection: direction, withRotationSpeed: rotationSpeed)
    }
}
