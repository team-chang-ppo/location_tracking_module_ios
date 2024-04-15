//
//  PurchaseCollectionViewCell.swift
//  AdminApp
//
//  Created by 승재 on 4/7/24.
//

import UIKit

class PurchaseCell: UICollectionViewCell {
    static let identifier = "PurchaseCell"
    
    private let titleLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 20, weight: .bold, width: .standard)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    private let descriptionLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 25, weight: .bold, width: .standard)
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 12
//        self.backgroundColor = .defaultCellColor
        
        [titleLabel, descriptionLabel, imageView].forEach { contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.leading.equalTo(contentView).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(imageView.snp.leading).offset(-30)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(40)
            $0.trailing.equalTo(contentView).offset(-30)
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ item : PurchaseInfo){
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        imageView.image = UIImage(named: item.imageName)
    }
}
