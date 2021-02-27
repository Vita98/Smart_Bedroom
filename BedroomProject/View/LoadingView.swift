//
//  loadingView.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 16/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit

private enum Visibility{
    case visible
    case hidden
}

public class LoadingView : UIVisualEffectView{
    
    public static let sharedInstance = LoadingView(effect: UIBlurEffect(style: .dark))
    private var visibility : Visibility = .hidden
    
    //Queue of all the caller of the loading view
    private var requestQueue : [String] = []
    
    public var isVisible : Bool {
        return visibility == .visible
    }
    
    
    
    private override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        //Setting the loading view with the same size of the screen
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        //Calling the function that set the activity indicator
        setActivityIndicator()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setActivityIndicator(){
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        
        self.contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        activityIndicator.startAnimating()
    }
    
    public func show(_ identifier : String, isAnimated animated : Bool){
        
        //If the caller is already a coller, don't do nothing
        if requestQueue.contains(identifier){
           return
        }
        
        //Adding the coller to the caller queue
        requestQueue.append(identifier)
        
        //Show the loading view only if not yet shown
        if visibility == .hidden{
            self.alpha = 0
            
            //Adding the loading view always on top of all view
            UIApplication.shared.keyWindow?.addSubview(self)
            
            if animated {
                UIView.animate(withDuration: 0.6) { self.alpha = 1 }
            }else{
                self.alpha = 1
            }
        }
    }
    
    public func hide(_ identifier : String, isAnimated animated: Bool){
        
        //Check if the caller of the hide command had already called the show
        if requestQueue.contains(identifier){
            
            //Remove from the request queue the caller
            requestQueue.removeAll(where: {$0 == identifier})
            
            //Dismiss the loading view only if the queue is empty
            if requestQueue.count == 0{
                
                if animated {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.6, animations: {
                            self.alpha = 0
                        }) { (flag) in
                            if flag{
                                self.removeFromSuperview()
                            }
                        }
                    }
                }else{
                    self.alpha = 0
                    self.removeFromSuperview()
                }
            }
        }
    }
    
}
