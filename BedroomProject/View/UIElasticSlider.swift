//
//  UIElasticSlider.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 12/09/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

class UIElasticSlider: UIControl {

    public let minimumValue : Int = -100
    public let maximumValue : Int = 100
    
    private(set) var value : Int = 0
    
    private let horizontalBar : UIView = {
        let bar = UIView()
        bar.layer.cornerRadius = 5
        bar.clipsToBounds = true
        bar.layer.masksToBounds = true
        bar.backgroundColor = .white
        return bar
    }()
    
    private let verticalNotch : UIView = {
        let notch = UIView()
        notch.backgroundColor = .white
        notch.layer.borderColor = UIColor.black.cgColor
        notch.layer.borderWidth = 0.3
        return notch
    }()
    
    private let circle : UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4.0
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let horizontalBarGradientLayer : CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor]
        gradientLayer.locations = [0, 0.25, 0.5, 0.75, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()
    
    
    private let unlockLabel : UILabel = {
        let label = UILabel()
        label.text = "Unlock"
        return label
    }()
    
    private let lockLabel : UILabel = {
        let label = UILabel()
        label.text = "Lock"
        return label
    }()
    
    private let leftHideView = UIView()
    private let rightHideView = UIView()
    
    public var delegate : UiElasticSliderDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        insertAllComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        insertAllComponent()
    }
    
    
    private func insertAllComponent(){
        setAllComponentHorizontalBar()
        
        self.addSubview(verticalNotch)
        
        verticalNotch.translatesAutoresizingMaskIntoConstraints = false
        verticalNotch.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        verticalNotch.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        verticalNotch.widthAnchor.constraint(equalToConstant: 5).isActive = true
        verticalNotch.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        self.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        circle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(circlePanGesture(sender:))))
        
        //Setting the label
        self.insertSubview(unlockLabel, belowSubview: circle)
        
        unlockLabel.translatesAutoresizingMaskIntoConstraints = false
        unlockLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        unlockLabel.topAnchor.constraint(equalTo: horizontalBar.bottomAnchor, constant: 5).isActive = true
        unlockLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        unlockLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        self.insertSubview(lockLabel, belowSubview: circle)
        
        lockLabel.translatesAutoresizingMaskIntoConstraints = false
        lockLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        lockLabel.topAnchor.constraint(equalTo: horizontalBar.bottomAnchor, constant: 5).isActive = true
        lockLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        lockLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
    }
    
    private func setAllComponentHorizontalBar(){
        self.addSubview(horizontalBar)
        
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        horizontalBar.heightAnchor.constraint(equalToConstant: 9).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        horizontalBar.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        horizontalBar.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        horizontalBarGradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.8, height: 9)
        horizontalBar.layer.insertSublayer(horizontalBarGradientLayer, at: 0)
        
        //Configuring the leftHideView
        horizontalBar.addSubview(leftHideView)
        
        leftHideView.translatesAutoresizingMaskIntoConstraints = false
        leftHideView.topAnchor.constraint(equalTo: horizontalBar.topAnchor, constant: 0).isActive = true
        leftHideView.leadingAnchor.constraint(equalTo: horizontalBar.leadingAnchor, constant: 0).isActive = true
        leftHideView.heightAnchor.constraint(equalToConstant: 9).isActive = true
        leftHideView.widthAnchor.constraint(equalTo: horizontalBar.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
        leftHideView.backgroundColor = .white
        
        //Configuring the rightHideView
        horizontalBar.addSubview(rightHideView)
        
        rightHideView.translatesAutoresizingMaskIntoConstraints = false
        rightHideView.topAnchor.constraint(equalTo: horizontalBar.topAnchor, constant: 0).isActive = true
        rightHideView.trailingAnchor.constraint(equalTo: horizontalBar.trailingAnchor, constant: 0).isActive = true
        rightHideView.heightAnchor.constraint(equalToConstant: 9).isActive = true
        rightHideView.widthAnchor.constraint(equalTo: horizontalBar.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
        rightHideView.backgroundColor = .white
    }
    
    public func changeColorTheme(with colorTheme : ColorTheme){
        if colorTheme == .Dark { setDarkTheme() }
        else { setLightTheme() }
    }
    
    var startLocation = CGPoint()
    
    @objc func circlePanGesture(sender : UIPanGestureRecognizer){
        
        guard sender.view != nil else { return }
        let translation = sender.translation(in: sender.view!.superview)

        let maxExtension = horizontalBar.frame.width / 2

        switch sender.state {
        case .began:
            startLocation = sender.view!.center
            
        case .cancelled:
            UIView.animate(withDuration: 0.2, animations: {
                sender.view!.center = self.startLocation
                self.leftHideView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightHideView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) {(flag) in
                self.value = 0
                
                if let delegate = self.delegate{
                    delegate.statusChanged(.Forwards, 0)
                }
                print("Actual Value: \(self.value)")
            }
            
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                sender.view!.center = self.startLocation
                self.leftHideView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.rightHideView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) {(flag) in
                self.value = 0
                
                if let delegate = self.delegate{
                    delegate.statusChanged(.Forwards, 0)
                }
                print("Actual Value: \(self.value)")
            }
            
        default:
            if translation.x >= maxExtension || translation.x <= -(maxExtension) {
                self.value = Int(100 * (translation.x < 0 ? -1 : 1) )
            }else{
                let newCenter = CGPoint(x: startLocation.x + translation.x, y: startLocation.y )

                UIView.animate(withDuration: 0.1, animations: {
                    sender.view!.center = newCenter
                    if translation.x > 0{
                        self.rightHideView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                        self.leftHideView.transform = CGAffineTransform(translationX: 0, y: 0)
                    }
                    else {
                        self.leftHideView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                        self.rightHideView.transform =  CGAffineTransform(translationX: 0, y: 0)
                    }
                },completion: {(flag) in
                    self.value = Int((100 / maxExtension) * translation.x)
                })
            }
        }
        if let delegate = self.delegate{
            delegate.statusChanged( self.value > 0 ? .Forwards : .Backwards , abs(self.value))
        }
        print("Actual Value: \(self.value)")
    }
    
}

extension UIElasticSlider : ThemeDelegate {
    internal func setDarkTheme() {
        unlockLabel.textColor = .black
        lockLabel.textColor = .black
    }
    
    internal func setLightTheme() {
        unlockLabel.textColor = .white
        lockLabel.textColor = .white
    }
}
