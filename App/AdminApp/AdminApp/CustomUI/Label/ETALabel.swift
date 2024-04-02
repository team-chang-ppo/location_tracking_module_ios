//
//  ETALabel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit

enum ETALabelType {
    case Header1
    case Header2
    case Header3
    case Header4
    case Header5
    case Header6
    
    case Subhead1
    case Subhead2
    case Subhead3
    case Subhead4
    case Subhead5
    case Subhead6
    
    case Body1
    case Body2
    case Body3
    case Body4
    case Body5
    case Body6
    
    case Caption1
    case Caption2
    case Caption3
}

final class ETALabel: UILabel {
    convenience init(type: ETALabelType, text: String = "", textColor: UIColor = .Grey50){
        self.init()
        configure(type: type, text: text, textColor: textColor)
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 자간(Kerning) 설정
    private func adjustKerning(_ value: CGFloat){
        guard let attributedText = self.attributedText else { return }
        let newAttributedText = NSMutableAttributedString(attributedString: attributedText)
        newAttributedText.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: newAttributedText.length))
        self.attributedText = newAttributedText
    }
    
    private func configure(type: ETALabelType, text: String, textColor: UIColor){
        self.text = text
        self.textColor = textColor
        self.numberOfLines = 0
        self.sizeToFit()
        self.adjustKerning(-0.2) // 글자 간격
        self.textAlignment = .justified // 양쪽 정렬
        switch type {
        case .Header1:
            self.font = .pretendard(.Bold, size: 64)
        case .Header2:
            self.font = .pretendard(.Bold, size: 48)
        case .Header3:
            self.font = .pretendard(.Bold, size: 40)
        case .Header4:
            self.font = .pretendard(.Bold, size: 36)
        case .Header5:
            self.font = .pretendard(.Bold, size: 32)
        case .Header6:
            self.font = .pretendard(.Bold, size: 28)
        case .Subhead1:
            self.font = .pretendard(.Bold, size: 24)
        case .Subhead2:
            self.font = .pretendard(.Bold, size: 20)
        case .Subhead3:
            self.font = .pretendard(.SemiBold, size: 20)
        case .Subhead4:
            self.font = .pretendard(.SemiBold, size: 16)
        case .Subhead5:
            self.font = .pretendard(.Bold, size: 16)
        case .Subhead6:
            self.font = .pretendard(.SemiBold, size: 16)
        case .Body1:
            self.font = .pretendard(.Medium, size: 16)
        case .Body2:
            self.font = .pretendard(.Medium, size: 14)
        case .Body3:
            self.font = .pretendard(.Regular, size: 14)
        case .Body4:
            self.font = .pretendard(.SemiBold, size: 12)
        case .Body5:
            self.font = .pretendard(.Regular, size: 12)
        case .Body6:
            self.font = .pretendard(.Light, size: 12)
        case .Caption1:
            self.font = .pretendard(.Medium, size: 12)
        case .Caption2:
            self.font = .pretendard(.SemiBold, size: 10)
        case .Caption3:
            self.font = .pretendard(.Medium, size: 10)
        }
    }
}
