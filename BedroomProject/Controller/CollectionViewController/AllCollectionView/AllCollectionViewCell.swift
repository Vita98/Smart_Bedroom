//
//  AllCollectionViewCell.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 05/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

protocol AllCollectionViewCellDelegate : ButtonPressedDelegate {}

class AllCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconButton: UIButton!
    
    public var delegate : ButtonPressedDelegate?
    
    @IBAction func iconButtonTouchUpInside(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.buttonPressed(Int(iconButton.accessibilityIdentifier ?? "") ?? -1)
        }
    }
}
