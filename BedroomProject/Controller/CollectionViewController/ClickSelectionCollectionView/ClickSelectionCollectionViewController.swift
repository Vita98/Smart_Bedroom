//
//  ClickSelectionCollectionViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 08/09/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ClickSelectionCollectionViewCell"

class ClickSelectionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var actualCellSelectedID = ""
    private var oldCellSelectdID = ""
    private var actualSelectedIndexPath : IndexPath!
    
    private let hideView : UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
       view.alpha = 0
       return view
    }()
    
    private var isInitialScroll = true
    
    private let container : UIView
    private let switchController : UISwitch
    
    private var collectionViewStatus : CollectionViewStatus = .showing
    
    private enum CollectionViewStatus {
        case showing
        case middleHiding
        case hiding
    }
    
    public var buttonClickSelectedDelegate : ButtonClickSelectedDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }
    
    convenience init(withIndexButtonSelected buttonSelectedIndex : Int, withContainer container : UIView, withSwitchController switchController: UISwitch) {
        self.init(withContainer: container, withSwitchController: switchController)
        
        //Call the function to scroll in the position of the selected item
        scrollCollectionView(toButton: buttonSelectedIndex, animated: false)
    }
    
    private init(withContainer container : UIView, withSwitchController switchController: UISwitch) {
        self.container = container
        self.switchController = switchController
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CollectionViewCellSize
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = .none
        collectionView.alwaysBounceHorizontal = true
        
        // Register cell classes
        self.collectionView!.register(ClickSelectionCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func scrollCollectionView(toButton buttonSelectedIndex : Int, animated : Bool){
        
        //Getting the position of the new selected button inside the ALL_COLLECTION_VIEW_BUTTON array
        guard let newIndex = ALL_COLLECTION_VIEW_BUTTON.firstIndex(of: buttonSelectedIndex ) else { return }
        
        //Index path of the new selected button
        let newButtonIndexPath = IndexPath(row: newIndex, section: 0)
        
        //Setting the variable for the tick render
        actualSelectedIndexPath = newButtonIndexPath
        actualCellSelectedID = String(buttonSelectedIndex)
        
        //Scrolling to the position on the main thread
        DispatchQueue.main.async {
            self.collectionView.delegate = self
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            
            self.collectionView.scrollToItem(at: newButtonIndexPath, at: .centeredHorizontally, animated: animated)
        }
        
        
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ALL_COLLECTION_VIEW_BUTTON.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClickSelectionCollectionViewCell
        
        //Configuring the cell
        cell.iconView.image = UIImage(named: REMOTE_BUTTON[ALL_COLLECTION_VIEW_BUTTON[indexPath.row]] ?? DefaultImagePathCollectionView)
        cell.iconView.accessibilityIdentifier = String(ALL_COLLECTION_VIEW_BUTTON[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        
        //Used mainly when reloaItem() is called for presenting or hiding the selected cell
        if actualCellSelectedID == cell.iconView.accessibilityIdentifier {
            cell.selectCell(animation: true)
        }else if oldCellSelectdID == cell.iconView.accessibilityIdentifier {
            cell.deselectCell(animation: true)
        }else{
            cell.deselectCell(animation: false)
        }
        
        return cell
    }

    
    public func disableAllContainer(animation : Bool){
        switch self.collectionViewStatus {
        case .showing:
            switchController.isEnabled = false
            disableCollectionView(animation: animation)
        case .middleHiding:
            switchController.isEnabled = false
        case .hiding:
            return
        }
        
        collectionViewStatus = .hiding
    }
    
    public func enableAllContainer(animation : Bool){
        if collectionViewStatus != .showing {
            
            if switchController.isOn {
                UIView.animate(withDuration: animation == true ? 0.2 : 0, animations: {
                    self.hideView.alpha = 0
                    self.switchController.isEnabled = true
                }) { (flag) in
                    self.hideView.removeFromSuperview()
                    self.collectionViewStatus = .showing
                }
            }else{
                UIView.animate(withDuration: animation == true ? 0.2 : 0, animations: {
                    self.switchController.isEnabled = true
                }) { (flag) in
                    self.collectionViewStatus = .middleHiding
                }
            }
        }
    }
    
    public func disableCollectionView(animation : Bool){
        
        if collectionViewStatus == .showing {
            container.insertSubview(hideView, belowSubview: switchController)
            
            hideView.translatesAutoresizingMaskIntoConstraints = false
            hideView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
            hideView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
            hideView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
            hideView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
            hideView.layer.cornerRadius = 15
            hideView.clipsToBounds = true
            
            UIView.animate(withDuration: animation == true ? 0.2 : 0 , animations: {
                self.hideView.alpha = 1
            })
            self.collectionViewStatus = .middleHiding
        }
    }
    
    public func enableCollectionView(animation : Bool){
        
        if collectionViewStatus == .middleHiding {
            UIView.animate(withDuration: animation == true ? 0.2 : 0, animations: {
                self.hideView.alpha = 0
            }) { (flag) in
                self.hideView.removeFromSuperview()
                self.collectionViewStatus = .showing
            }
        }
    }
}


extension ClickSelectionCollectionViewController : ClickSelectionCollectionViewCellDelegate {
    
    func didTouchIconButton(withCellTapped cellTapped: ClickSelectionCollectionViewCell) {
        cellTapped.selectCell(animation: true)
        
        oldCellSelectdID = actualCellSelectedID
        actualCellSelectedID = cellTapped.iconView.accessibilityIdentifier ?? ""
        
        if let selectdDelegate = buttonClickSelectedDelegate, let button = Int(actualCellSelectedID){
            selectdDelegate.buttonSelected(button, container)
        }
        
        if let oldSelectedIndexPath = actualSelectedIndexPath{
            collectionView.reloadItems(at: [oldSelectedIndexPath])
        }
        actualSelectedIndexPath = cellTapped.indexPath
    }
    
}
