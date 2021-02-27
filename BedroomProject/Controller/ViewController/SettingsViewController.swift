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
    
    @IBOutlet weak var singleClickComponentContainer: UIView!
    @IBOutlet weak var longClickComponentContainer: UIView!
    @IBOutlet weak var stairComponentContainer: UIView!
    
    @IBOutlet weak var singleClickSwitch: UISwitch!
    @IBOutlet weak var longClickSwitch: UISwitch!
    @IBOutlet weak var generalEnablerSwitch: UISwitch!
    
    private var customElasticSlider : UIElasticSlider?
    
    private var singleClickCollectionViewController : ClickSelectionCollectionViewController!
    private var longClickCollectionViewController : ClickSelectionCollectionViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setBackgroundView()

        // Do any additional setup after loading the view.
        configureClickSection()
        configureElesticSlider()
        
        setInitialStatusValues()
        
        if appColorTheme == .Dark{ setDarkTheme() }
        else { setLightTheme() }
        
        singleClickCollectionViewController.buttonClickSelectedDelegate = self
        longClickCollectionViewController.buttonClickSelectedDelegate = self
        
        //Notification observer for the theme color change
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkTheme), name: lightThemeSelectedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightTheme), name: darkThemeSelectedNotificationName, object: nil)
        
        //Notification observer for the completed setup action
        NotificationCenter.default.addObserver(self, selector: #selector(setupCompletedActions), name: setupCompletedNotificationName, object: nil)
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
        }
        
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
    
    @IBAction func singleClickSwitchValueChanged(_ sender: Any) {
        if singleClickSwitch.isOn{
            singleClickCollectionViewController.enableCollectionView(animation: true)
            
            isSingleClickWallEnabled = true
            WIFIModuleConnectionManager.sharedInstance.sendSingleClickWallButtonCommand()
        }else {
            singleClickCollectionViewController.disableCollectionView(animation: true)
            
            isSingleClickWallEnabled = false
            WIFIModuleConnectionManager.sharedInstance.sendSingleClickWallButtonCommand()
        }
    }
    
    @IBAction func ClickSwitchValueChanged(_ sender: Any) {
        if longClickSwitch.isOn{
            longClickCollectionViewController.enableCollectionView(animation: true)
            
            isLongClickWallEnabled = true
            WIFIModuleConnectionManager.sharedInstance.sendLongPressionWallButtonCommand()
        }else {
            longClickCollectionViewController.disableCollectionView(animation: true)
            
            isLongClickWallEnabled = false
            WIFIModuleConnectionManager.sharedInstance.sendLongPressionWallButtonCommand()
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
        if let slider = customElasticSlider { slider.changeColorTheme(with: .Dark)}
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func setLightTheme() {
        wallButtonLabel.textColor = .white
        enabledLabel.textColor = .white
        stairLabel.textColor = .white
        singleClickLabel.textColor = .white
        longClickLabel.textColor = .white
        if let slider = customElasticSlider { slider.changeColorTheme(with: .Light)}
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
    }
}

extension SettingsViewController : ButtonClickSelectedDelegate {
    
    func buttonSelected(_ button: RemoteButtonIndex, _ container: UIView) {
        switch container {
        case singleClickComponentContainer:
            singleClickWallButtonID = button
            WIFIModuleConnectionManager.sharedInstance.sendSingleClickWallButtonCommand()
        case longClickComponentContainer:
            longClickWallButtonID = button
            WIFIModuleConnectionManager.sharedInstance.sendLongPressionWallButtonCommand()
        default:
            print("Neither single click or long!")
        }
    }
    
}

extension SettingsViewController : UiElasticSliderDelegate {
    func statusChanged(_ direction: StairDirection, _ rotationSpeed: Int) {
        WIFIModuleConnectionManager.sharedInstance.sendStairCommand(withDirection: direction, withRotationSpeed: rotationSpeed)
    }
}
