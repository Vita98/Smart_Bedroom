//
//  BackgroundImageManager.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 29/02/2020.
//  Copyright © 2020 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit

class BackgroundImageManager {
    
    public static let sharedInstance = BackgroundImageManager()
    
    private let key = "background"
    
    private init() {}
    
    public func getSavedBackgroundImage() -> UIImage?{
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
            let image = UIImage(data: imageData) {
            
            return image
        }
        return nil
    }
    
    public func updateBackgroundImage(newBackground : UIImage){
        if let pngRepresentation = newBackground.pngData() {
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.set(pngRepresentation, forKey: key)
        }
    }
    
}
