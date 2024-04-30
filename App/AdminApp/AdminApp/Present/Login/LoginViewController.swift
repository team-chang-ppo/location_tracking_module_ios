//
//  ViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/15/24.
//

import UIKit
import Combine


class LoginViewController: UIViewController {
    
    private let KaKaoLoginBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitle("카카오로 로그인하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .defaultBackgroundColor
        self.view.addSubview(KaKaoLoginBtn)
        KaKaoLoginBtn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            KaKaoLoginBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            KaKaoLoginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            KaKaoLoginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            KaKaoLoginBtn.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func didTapSignIn() {
        let vc = KaKaoLoginWebViewController()
        vc.completionHandler = { success in
            self.handleSignIn(success: success)
        }
        vc.modalPresentationStyle = .pageSheet
        self.present(vc,animated: true)
    }
    
    private func handleSignIn(success: Bool){
        
        guard success else {
            let alert = UIAlertController(title: "로그인 오류", message: "알수없는 오류로 로그인에 실패했습니다. ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let homeVC = HomeViewController()
        
        homeVC.navigationItem.hidesBackButton = true
        homeVC.navigationItem.title = "인증키 관리"
        homeVC.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
}
