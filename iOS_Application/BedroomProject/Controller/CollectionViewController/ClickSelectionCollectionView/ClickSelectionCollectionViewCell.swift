//
//  ClickSelectionCollectionViewCell.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 08/09/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

protocol ClickSelectionCollectionViewCellDelegate {
    func didTouchIconButton(withCellTapped cellTapped : ClickSelectionCollectionViewCell)
}

class ClickSelectionCollectionViewCell: UICollectionViewCell {
    
    var iconView : UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       return imageView
    }()
    
    private let shadowMaskView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.41)
        return view
    }()
    
    private let greenTickImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "GREENTICK"))
       imageView.contentMode = .scaleAspectFit
       imageView.alpha = 0
       return imageView
    }()
    
    
    var delegate : ClickSelectionCollectionViewCellDelegate!
    private(set) var isButtonSelected = false
    
    public var indexPath = IndexPath(row: 0, section: 0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponent(){
        
        //Adding the view with the image of the button
        self.addSubview(iconView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        //Adding the view as a mask for the selection
        iconView.addSubview(shadowMaskView)
        
        shadowMaskView.translatesAutoresizingMaskIntoConstraints = false
        shadowMaskView.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0).isActive = true
        shadowMaskView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: 0).isActive = true
        shadowMaskView.trailingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 0).isActive = true
        shadowMaskView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0).isActive = true
        
        let path = UIBezierPath(arcCenter: CGPoint(x: CollectionViewCellSize.width / 2, y: CollectionViewCellSize.height / 2), radius: CollectionViewCellSize.width / 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.backgroundColor = .none
        shadowMaskView.layer.mask = layer
        
        //Adding the view with the green tick for the selection
        iconView.insertSubview(greenTickImageView, belowSubview: shadowMaskView)
        
        greenTickImageView.translatesAutoresizingMaskIntoConstraints = false
        greenTickImageView.topAnchor.constraint(equalTo: iconView.topAnchor, constant: -5).isActive = true
        greenTickImageView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -5).isActive = true
        greenTickImageView.trailingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 5).isActive = true
        greenTickImageView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 5).isActive = true
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let delegate = self.delegate{
            delegate.didTouchIconButton(withCellTapped : self)
        }
    }
    
    public func deselectCell(animation : Bool ){
        
        if animation {
            
            self.greenTickImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.isButtonSelected = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.shadowMaskView.alpha = 1
                
                //Animating the fadeOut transiction of the tick
                self.greenTickImageView.alpha = 0
                self.greenTickImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            })

        }else{
            self.shadowMaskView.alpha = 1
            self.greenTickImageView.alpha = 0
            self.isButtonSelected = false
        }

    }

    public func selectCell(animation : Bool){
        if animation{
            
            self.greenTickImageView.transform = CGAffineTransform(scaleX: 0.1 , y: 0.1)
            self.isButtonSelected = true
            UIView.animate(withDuration: 0.3, animations: {
                self.shadowMaskView.alpha = 0
                
                //Animating the fadeIn transiction of the tick
                self.greenTickImageView.alpha = 1
                self.greenTickImageView.transform = CGAffineTransform(scaleX: 1 , y: 1)
            })
        }else{
            self.shadowMaskView.alpha = 0
            self.greenTickImageView.alpha = 1
            self.isButtonSelected = true
        }
    }
    
}
