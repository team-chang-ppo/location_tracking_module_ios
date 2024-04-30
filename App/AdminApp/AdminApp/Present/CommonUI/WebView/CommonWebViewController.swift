//
//  CommonWebViewController.swift
//  AdminApp
//
//  Created by 승재 on 4/4/24.
//

import UIKit
import WebKit

class CommonWebViewController: UIViewController {
    var webView: WKWebView!
    var url: URL?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
