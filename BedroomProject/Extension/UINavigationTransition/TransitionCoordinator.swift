//
//  TransitionCoordinator.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 06/09/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation
import UIKit

final class TransitionCoordinator : NSObject, UINavigationControllerDelegate{
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return TransitionAnimator(presenting: true)
        case .pop:
            return TransitionAnimator(presenting: false)
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
