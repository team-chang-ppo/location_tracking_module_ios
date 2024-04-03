//
//  InfoCell.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import UIKit
import SnapKit
import Then

class HomePagingItemCell: UICollectionViewCell {
    static let identifier = "HomePagingItemCell"
    private let titleLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 16, weight: .bold, width: .standard)
        $0.numberOfLines = 1
    }
    private let descriptionLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 30, weight: .bold, width: .standard)
        $0.tintColor = .label
        $0.numberOfLines = 0
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true //이미지 벡터로 저장함
        $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .Grey300
    }
    private let arrowImage = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.forward")
    }
    
    private let buttonLabel = ETALabel(type: .Caption1, text: "더 알아보기", textColor: .LightBlue400)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
        self.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                // 다크 모드일 때의 색상
                return .Grey900
            default:
                // 라이트 모드 또는 기타 모드일 때의 색상
                return .white
            }
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(arrowImage)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.left.equalTo(contentView).offset(20)
        }
        
        arrowImage.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalTo(contentView).offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-30)
        }
        
        imageView.snp.makeConstraints {
            
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.bottom.equalTo(contentView).offset(-35)
            $0.centerX.equalTo(contentView)
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
    }
    
    
    
    func configure(_ item: PagingItem) {
        switch item.color{
        case .green:
            titleLabel.textColor = .Green700
            imageView.tintColor = .Green700
            arrowImage.tintColor = .Green700
        case .grey:
            titleLabel.textColor = .Grey700
            imageView.tintColor = .Grey700
            arrowImage.tintColor = .Grey700
        case .lightblue:
            titleLabel.textColor = .LightBlue700
            imageView.tintColor = .LightBlue700
            arrowImage.tintColor = .LightBlue700
        case .lightgreen:
            titleLabel.textColor = .LightGreen700
            imageView.tintColor = .LightGreen700
            arrowImage.tintColor = .LightGreen700
        case .yellow:
            titleLabel.textColor = .Yellow700
            imageView.tintColor = .Yellow700
            arrowImage.tintColor = .Yellow700
        }
        
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        if let iconName = item.iconImage, !iconName.isEmpty {
            // 시스템 이미지 이름으로 UIImage 생성
            imageView.image = UIImage(systemName: iconName)
        } else if let imageName = item.imageName, !imageName.isEmpty {
            // 일반 이미지 이름으로 UIImage 생성
            imageView.image = UIImage(named: imageName)
        }
        
        
        
        
    }
}

extension HomePagingItemCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateShrinkDown()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateReturnToOriginalSize()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateReturnToOriginalSize()
    }
    
    private func animateShrinkDown() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func animateReturnToOriginalSize() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}
