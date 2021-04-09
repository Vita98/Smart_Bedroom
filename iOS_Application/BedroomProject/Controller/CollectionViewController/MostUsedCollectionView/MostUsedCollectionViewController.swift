//
//  FF.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 26/06/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit

class MostUsedCollectionViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , ButtonPressedDelegate{
    
    let reusableCellIdentifier = "MostUsedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MOST_USED_BUTTON.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellIdentifier, for: indexPath) as! MostUsedCollectionViewCell
    
        cell.iconButton.setImage(UIImage(named: REMOTE_BUTTON[MOST_USED_BUTTON[indexPath.row]] ?? DefaultImagePathCollectionView), for: .normal)
        cell.iconButton.imageView?.contentMode = .scaleAspectFit
        cell.iconButton.accessibilityIdentifier = String(MOST_USED_BUTTON[indexPath.row])
        cell.buttonPressedDelegate = self
        cell.backgroundColor = .none
        
        return cell
    }
    
    func buttonPressed(_ button: RemoteButtonIndex) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: button)
    }
    
}

