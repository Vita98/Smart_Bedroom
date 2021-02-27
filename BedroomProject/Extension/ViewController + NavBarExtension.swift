//
//  ViewController + NavBarExtension.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 26/06/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

extension ViewController {
        
    public func setNavigatioBar(){
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.barStyle = .black
    
        
        let label = UILabel()
        label.text = "Bedroom"
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.textColor = .white
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (navigationController?.navigationBar.frame.height)!))
        view.backgroundColor = .clear
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "SETTINGS_WHITE"), for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        settingsButton.widthAnchor.constraint(lessThanOrEqualTo: label.heightAnchor, multiplier: 1).isActive = true
        settingsButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: view.frame.width * 0.4).isActive = true
        
        settingsButton.addTarget(self, action: #selector(settingButtonTouchUpInside(_:)), for: .touchUpInside)
        
        self.settingsButton = settingsButton
        
        self.navigationItem.titleView = view
        navigationBarTitleLabel = label
    }
    
    public func changeSettingsIcon(withStyle style : UIBarStyle){
        switch style {
        case .black:
            if let settingsButton = settingsButton{
                settingsButton.setImage(UIImage(named: "SETTINGS_WHITE"), for: .normal)
            }
        case .default:
            if let settingsButton = settingsButton{
                settingsButton.setImage(UIImage(named: "SETTINGS_BLACK"), for: .normal)
            }
        default:
            if let settingsButton = settingsButton{
                settingsButton.setImage(UIImage(named: "SETTINGS_BLACK"), for: .normal)
            }
        }
    }
    
}

extension UIImageView {
    
    func getImageName() -> String? {
        
        if let image = self.image, let imageName = image.accessibilityIdentifier {
            return imageName
        } else {
            return nil
        }
        
    }
    
}
