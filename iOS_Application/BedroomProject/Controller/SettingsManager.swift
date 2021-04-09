//
//  SettingsManager.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 06/03/21.
//  Copyright © 2021 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit

class SettingsManager{
    
    public static let sharedInstance = SettingsManager()
    
    private let backgroundImageKey = "background"
    private let downloadRandomBackground = "randomBackground"
    
    public var randomBackgroundProperty : Bool {
        set {
            UserDefaults.standard.removeObject(forKey: downloadRandomBackground)
            UserDefaults.standard.set(newValue, forKey: downloadRandomBackground)
        }
        
        get {
            return UserDefaults.standard.bool(forKey: downloadRandomBackground)
        }
    }
    
    public var backgroundImage : UIImage? {
        set {
            if let newValue = newValue, let pngRepresentation = newValue.pngData() {
                UserDefaults.standard.removeObject(forKey: backgroundImageKey)
                UserDefaults.standard.set(pngRepresentation, forKey: backgroundImageKey)
            }
        }
        
        get {
            if let imageData = UserDefaults.standard.object(forKey: backgroundImageKey) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
            return nil
        }
    }
    
    private init() {}
    
}
