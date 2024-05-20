//
//  GithubLoginWebViewController.swift
//  AdminApp
//
//  Created by 승재 on 5/20/24.
//

import UIKit
import WebKit
import Combine

class GithubLoginWebViewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var completionHandler: ((Bool) -> Void)?
    
    let networkService = NetworkService(configuration: .default)
    var subscriptions = Set<AnyCancellable>()
    var webViews = [WKWebView]()
    var loginAttempted = false
    var url : String = Config.githubUri
    
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
        
        let webView = createWebView(frame: self.view.bounds, configuration: config)
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
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
        print(webView.url?.absoluteString ?? "")
        
        guard let urlString = webView.url?.absoluteString else { return }
        if webView.url?.absoluteString.contains("success") ?? false {
            print("Github Login successful!")
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    if cookie.name == "JSESSIONID"{
                        print("Cookie: \(cookie.name)=\(cookie.value)")
                        if let data = cookie.value.data(using: .utf8){
                            self.clearCookies()
                            KeychainManager.save(key: "SessionID", data: data)
                            self.webViews.removeAll()
                            self.completionHandler!(true)
                            self.dismiss(animated: true)
                            return
                        }else{
                            self.completionHandler!(false)
                            self.dismiss(animated: true)
                            return
                        }
                    }
                    
                }
            }
        }else if webView.url?.absoluteString.contains("error") ?? false {
            self.completionHandler!(false)
            self.dismiss(animated: true)
            return
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
        
        // 카카오링크 스킴인 경우 open을 시도합니다.
        if let url = navigationAction.request.url
            , ["kakaokompassauth", "kakaolink", "kakaotalk"].contains(url.scheme) {
            print("Execute KakaoLink!")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
        if navigationAction.targetFrame == nil {
            print("navigtiaonActionuing\n")
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
    private func clearCookies() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            for record in records {
                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    print("Deleted: \(record.displayName)")
                })
            }
        }
    }
}
