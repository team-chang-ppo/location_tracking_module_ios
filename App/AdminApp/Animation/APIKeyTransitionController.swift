//
//  APiKeyTransitionController.swift
//  AdminApp
//
//  Created by 승재 on 3/20/24.
//

import Foundation
import UIKit

class APIKeyTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    var superViewcontroller: UIViewController?
    var indexPath: IndexPath?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AppcontentPresentaion(presentedViewController: presented, presenting: presenting)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nill
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nill
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
