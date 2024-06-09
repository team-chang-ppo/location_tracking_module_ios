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
    
    func handleError(_ error: CommonError) {
            switch error {
            case .encodingFailed:
                showConfirmationPopup(mainText: "네트워크 오류", subText: "EncodingFailed", centerButtonTitle: "확인")
            case .networkFailure(let error):
                showConfirmationPopup(mainText: "네트워크 오류", subText: "세션이 만료되었습니다. 다시 로그인해주세요.", centerButtonTitle: "확인") {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            let vc = LoginViewController()
                            vc.modalPresentationStyle = .fullScreen
                            vc.title = "로그인"
                            self.present(vc, animated: true)
                        }
                    }
                }
            case .invalidResponse:
                showConfirmationPopup(mainText: "네트워크 오류", subText: "invalidResponse", centerButtonTitle: "확인")
            case .unknown:
                showConfirmationPopup(mainText: "네트워크 오류", subText: "알수없는 에러", centerButtonTitle: "확인")
            }
        }
}
