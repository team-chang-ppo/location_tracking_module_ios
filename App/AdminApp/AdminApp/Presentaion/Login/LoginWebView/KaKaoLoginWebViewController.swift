//
//  AuthViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/18/24.
//

import UIKit
import WebKit

class KaKaoLoginWebViewController: UIViewController{
    var completionHandler: ((Bool) -> Void)?
    var webViews = [WKWebView]()
    var loginAttempted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configureWebView(self)
    }
}
