//
//  TextField+.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit

extension UITextField {
    func addLeftPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
