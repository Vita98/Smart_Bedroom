//
//  TransitionAnimator.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 06/09/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit



final class TransitionAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting : Bool
    
    init(presenting : Bool){
        self.presenting = presenting
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? SuperViewController else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) as? SuperViewController else { return }
        
        if presenting{
            //Push
            
            print("\n\nPUSH\n\n")
            let duration = transitionDuration(using: transitionContext)
            
            let container = transitionContext.containerView
            container.addSubview(toViewController.view)
            toViewController.blurEffectView.effect = .none
            
            toViewController.view.frame = CGRect(x: toViewController.view.frame.width, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height)
            
            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.frame = CGRect(x: -fromViewController.view.frame.width, y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height)
                
                //Sliding the background image below the destination ViewController
                fromViewController.backgroundView.frame = CGRect(x: fromViewController.view.frame.width, y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height)
                
                //Presenting the destinationViewController
                toViewController.view.frame = CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height)
            }) { (flag) in
                container.addSubview(toViewController.view)
                
                //Passing the background image also to the destination controller
                toViewController.imageView.image = fromViewController.imageView.image
                toViewController.blurEffectView.effect = toViewController.defaultBlurEffect
                
                //Sliding back the background
                fromViewController.backgroundView.frame = CGRect(x: 0, y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height)
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }else{
            //Pop
            let duration = transitionDuration(using: transitionContext)
            
            let container = transitionContext.containerView
            container.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            
            toViewController.view.frame = CGRect(x: -toViewController.view.frame.width, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height)
            toViewController.backgroundView.frame = CGRect(x: toViewController.backgroundView.frame.width, y: 0, width: toViewController.backgroundView.frame.width, height: toViewController.backgroundView.frame.height)
            
            //Removing the background image from the destination controller
            fromViewController.imageView.image = nil
            fromViewController.blurEffectView.effect = .none
            
            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.frame = CGRect(x: fromViewController.view.frame.width, y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height)
                toViewController.view.frame = CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height)
                toViewController.backgroundView.frame = CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height)
                
            }) { (flag) in
                container.addSubview(toViewController.view)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                fromViewController.imageView.image = toViewController.imageView.image
                fromViewController.blurEffectView.effect = fromViewController.defaultBlurEffect
            }
            
        }
    }
}
