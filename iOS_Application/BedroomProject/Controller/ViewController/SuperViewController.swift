//
//  SuperViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 05/03/2020.
//  Copyright © 2020 VitandreaCorporation. All rights reserved.
//

import UIKit


class SuperViewController: UIViewController {
    
    var backgroundView = UIView()
    let imageView = UIImageView()
    let defaultBlurEffect = UIBlurEffect(style: .regular)
    var blurEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffectView = UIVisualEffectView(effect: defaultBlurEffect)
        blurEffectView.alpha = 1
        // Do any additional setup after loading the view.
    }
    
    public final func setBackgroundView(){
        self.view.insertSubview(backgroundView, at: 0)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        backgroundView.insertSubview(imageView, at: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0).isActive = true
        
        backgroundView.insertSubview(blurEffectView, at: 1)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 0).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0).isActive = true
        
    }
    
    public final func changeBackground(withNewImage newImage : UIImage, withFade : Bool){
        
        if withFade{
            let crossFade = CABasicAnimation(keyPath: "contents")
            crossFade.duration = 1
            crossFade.fromValue = imageView.image?.cgImage
            crossFade.toValue = newImage.cgImage
            
            imageView.image = newImage
            imageView.layer.add(crossFade, forKey: "animateContents")
        }else { imageView.image = newImage }
    }

}
