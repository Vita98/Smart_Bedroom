//
//  SuperViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 05/03/2020.
//  Copyright © 2020 VitandreaCorporation. All rights reserved.
//

import UIKit


class SuperViewController: UIViewController {
    
    let backgroundView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public final func setBackgroundView(){
        self.view.insertSubview(backgroundView, at: 0)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    
    public final func changeBackground(withNewImage newImage : UIImage, withFade : Bool){
        
        if withFade{
            let crossFade = CABasicAnimation(keyPath: "contents")
            crossFade.duration = 1
            crossFade.fromValue = backgroundView.image?.cgImage
            crossFade.toValue = newImage.cgImage
            
            backgroundView.image = newImage
            backgroundView.layer.add(crossFade, forKey: "animateContents")
        }else { backgroundView.image = newImage }
    }

}
