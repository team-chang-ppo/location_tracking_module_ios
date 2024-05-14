//
//  UIViewController+.swift
//  AdminApp
//
//  Created by 승재 on 5/14/24.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self as? UITabBarController, let selected = tab.selectedViewController {
            return selected.topMostViewController()
        }
        return self
    }
}
