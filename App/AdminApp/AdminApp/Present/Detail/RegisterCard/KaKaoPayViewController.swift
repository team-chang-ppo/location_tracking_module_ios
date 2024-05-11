//
//  KaKaoPayViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import UIKit
import WebKit


class KaKaoPayViewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var completionHandler: ((Bool) -> Void)?
    
    var webViews = [WKWebView]()
    var loginAttempted = false
    var url : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .defaultBackgroundColor
        self.configureWebView(self)
    }
    
    func configureWebView(_ sender: Any) {
        self.webViews.removeAll()
        // 웹 뷰 구성을 설정합니다.
        let config = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preferences
        config.allowsInlineMediaPlayback = true
        
        config.mediaTypesRequiringUserActionForPlayback = []
        config.ignoresViewportScaleLimits = true
        
        // 사용자 스크립트를 생성합니다.
        let jsString = """
        var script = document.createElement('script');
        script.src = "https://t1.kakaocdn.net/kakao_js_sdk/2.7.0/kakao.min.js";
        script.integrity = "sha384-l+xbElFSnPZ2rOaPrU//2FF5B4LB8FiX5q4fXYTlfcG4PGpMkE1vcL7kNXI6Cci0";
        script.crossOrigin = "anonymous";
        script.onload = function() {
            Kakao.init('d1f1554bcb9935a34113b5147fcca08b'); // Kakao SDK 초기화
        };
        document.head.appendChild(script);
        """
        let userScript = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript)
        
        let webView = createWebView(frame: self.view.bounds, configuration: config)
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    
    func createWebView(frame: CGRect, configuration: WKWebViewConfiguration) -> WKWebView {
        
        
        let webView = WKWebView(frame: frame, configuration: configuration)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        self.webViews.append(webView)
        
        return webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print(webView.url?.absoluteString)
        if webView.url?.absoluteString.contains("success") ?? false {
            print("Card Register successful!")
            self.webViews.removeAll()
            
            completionHandler?(true)
            
            self.dismiss(animated: true)
        }
    }
    
    /// ---------- 팝업 열기 ----------
    /// - 카카오 JavaScript SDK의 로그인 기능은 popup을 이용합니다.
    /// - window.open() 호출 시 별도 팝업 webview가 생성되어야 합니다.
    ///  새로운 인터넷 창이 뜬 경우 실행하는 함수
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let frame = self.webViews.last?.frame else {
            return nil
        }
        return createWebView(frame: frame, configuration: configuration)
    }
    
    /// ---------- 팝업 닫기 ----------
    /// - window.close()가 호출되면 앞에서 생성한 팝업 webview를 닫아야 합니다.
    ///
    func webViewDidClose(_ webView: WKWebView) {
        self.webViews.popLast()?.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print("webviewURL: \(navigationAction.request.url?.absoluteString)" ?? "")
        
        // 카카오링크 스킴인 경우 open을 시도합니다.
        if let url = navigationAction.request.url
            , ["kakaokompassauth", "kakaolink", "kakaotalk"].contains(url.scheme) {
            print("Execute KakaoLink!")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: webView.url?.host, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: webView.url?.host, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
