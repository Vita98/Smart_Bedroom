//
//  UIButtonExtensionisHiglighted.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 27/08/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        super.touchesCancelled(touches, with: event)
    }
    
}
