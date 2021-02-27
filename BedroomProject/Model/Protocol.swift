//
//  Protocol.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 31/10/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ThemeDelegate {
    @objc func setDarkTheme();
    @objc func setLightTheme();
}

protocol ButtonPressedDelegate {
    func buttonPressed(_ button : RemoteButtonIndex);
}

protocol ButtonClickSelectedDelegate {
    func buttonSelected(_ button : RemoteButtonIndex, _ container : UIView)
}

protocol UiElasticSliderDelegate {
    func statusChanged(_ direction : StairDirection, _ rotationSpeed : Int)
}
