//
//  ETAToastMessageView.swift
//  AdminApp
//
//  Created by 승재 on 5/9/24.
//

import UIKit
import Then
import SnapKit

enum ToastState{
    case check, warning
    
    var icon: UIImage{
        switch self {
        case.check:
            return UIImage(systemName: "checkmark.circle")!
        case .warning:
            return UIImage(systemName: "exclamationmark.circle")!
        }
    
    }
}
final class ETAToastMessageView: UIView {

    private let toastImage = UIImageView().then {
        $0.tintColor = .white
    }
    private let toastLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ETAToastMessageView {
    func setupStyle(){
        self.backgroundColor = .Grey800
        self.makeRounded(cornerRadius: 22)
    }
    
    func setupHierarchy(){
        [toastImage, toastLabel].forEach {
            self.addSubview($0)
        }
    }
    func setupLayout(){
        toastImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
        toastLabel.snp.makeConstraints{
            $0.leading.equalTo(toastImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
}

extension ETAToastMessageView {
    func setupDatabind(message: String, state: ToastState){
        toastImage.image = state.icon
        toastLabel.text = message
    }
}

extension UIViewController {
    func showToastMessage(width: CGFloat, state: ToastState, message: String){
        let toastView = ETAToastMessageView(frame: CGRect(x: view.center.x - width/2, y: view.frame.size.height - 46 - 100, width: width, height: 46))
        self.view.addSubview(toastView)
        toastView.setupDatabind(message: message, state: state)
        
        UIView.animate(withDuration: 3.0,
                       delay: 0.0,
                       options: [.curveEaseIn, .beginFromCurrentState],
                       animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
    
}

