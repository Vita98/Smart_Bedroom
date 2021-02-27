//
//  AllCollectionViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 05/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

class AllCollectionViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ButtonPressedDelegate {
    
    let reusableCellIdentifier = "AllCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ALL_COLLECTION_VIEW_BUTTON.count / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellIdentifier, for: indexPath) as! AllCollectionViewCell
        
        cell.iconButton.setImage(UIImage(named: REMOTE_BUTTON[ALL_COLLECTION_VIEW_BUTTON[indexPath.row]] ?? DefaultImagePathCollectionView), for: .normal)
        cell.iconButton.imageView?.contentMode = .scaleAspectFit
        cell.iconButton.accessibilityIdentifier = String(ALL_COLLECTION_VIEW_BUTTON[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func buttonPressed(_ button: RemoteButtonIndex) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: button)
    }
    
}
