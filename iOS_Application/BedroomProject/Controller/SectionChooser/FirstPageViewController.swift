//
//  FirstPageViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 04/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

class FirstPageViewController: UIViewController {

    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    
    var buttonPressedDelegate : ButtonPressedDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(setLightTheme), name: lightThemeSelectedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkTheme), name: darkThemeSelectedNotificationName, object: nil)
        // Do any additional setup after loading the view.
    }
    
}

extension FirstPageViewController {
    
    @IBAction func lessBrightTouchUpInside(_ sender: Any) {
        
        if let delegate = buttonPressedDelegate{
            delegate.buttonPressed(SPECIAL_REMOTE_BUTTON.LESSBRIGHT.rawValue)
        }
    }
    
    @IBAction func moreBrightTouchUpInside(_ sender: Any) {
        if let delegate = buttonPressedDelegate{
            delegate.buttonPressed(SPECIAL_REMOTE_BUTTON.MOREBRIGHT.rawValue)
        }
    }
    
    @IBAction func onTouchUpInside(_ sender: Any) {
        if let delegate = buttonPressedDelegate{
            delegate.buttonPressed(SPECIAL_REMOTE_BUTTON.ON.rawValue)
        }
    }
    
    @IBAction func offTouchUpInside(_ sender: Any) {
        if let delegate = buttonPressedDelegate{
            delegate.buttonPressed(SPECIAL_REMOTE_BUTTON.OFF.rawValue)
        }
    }
    
}

extension FirstPageViewController : ThemeDelegate {
    @objc func setDarkTheme(){
        onLabel.textColor = .black
        offLabel.textColor = .black
        brightnessLabel.textColor = .black
    }
    
    @objc func setLightTheme(){
        onLabel.textColor = .white
        offLabel.textColor = .white
        brightnessLabel.textColor = .white
    }
}
