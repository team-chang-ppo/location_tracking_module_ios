//
//  ETAButton.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit

enum ETAButtonState {
    case Default
    case Disabled
}

final class ETAButton: UIButton {
    convenience init(type: ETAButtonState, text: String = "") {
        self.init(frame: .zero)
        configure(type: type, text: text)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var isEnabled: Bool {
        didSet {
            updateButtonState()
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateButtonState(){
        if isEnabled{
            self.backgroundColor = .Main
            self.setTitleColor(.white, for: .normal)
        } else {
            self.backgroundColor = .Grey300
            self.setTitleColor(.Grey600, for: .normal)
        }
    }
    
    private func configure(type: ETAButtonState, text: String){
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 8
        self.titleLabel?.font = .pretendard(.SemiBold, size: 16)
        switch type {
        case .Default:
            self.backgroundColor = .Main
            self.setTitleColor(.white, for: .normal)
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: 360),
                self.heightAnchor.constraint(equalToConstant: 48)
            ])
        case .Disabled:
            self.backgroundColor = .Grey300
            self.setTitleColor(.Grey600, for: .normal)
            self.isEnabled = false
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: 360),
                self.heightAnchor.constraint(equalToConstant: 48)
            ])
        }
        
    }
}

