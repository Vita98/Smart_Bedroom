//
//  MostUsedCollectionViewCell.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 26/06/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

class MostUsedCollectionViewCell: UICollectionViewCell {
    @IBOutlet var iconButton: UIButton!
    
    var buttonPressedDelegate : ButtonPressedDelegate?
    
    @IBAction func iconButtonTouchUpInside(_ sender: Any) {
        if let delegate = self.buttonPressedDelegate{
            delegate.buttonPressed(Int(iconButton.accessibilityIdentifier ?? "0") ?? 0)
        }
    }
    
    
}
