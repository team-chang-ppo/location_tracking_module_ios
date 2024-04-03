//
//  HomeCollectionViewCellHeader.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//
import UIKit
import Then

class CustomCollectionViewCellHeader: UICollectionReusableView {
    static let identifier = "CustomCollectionViewCellHeader"
    
    private let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = UIColor.label
    }
    
    private let subtitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .lightGray
    }
    
    private let iconImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconImageView) // 아이콘 이미지 뷰 추가
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        // Icon ImageView Constraints
        iconImageView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.height.equalTo(24)
        }

        // Title Label Constraints
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(self.snp.trailing)
        }

        // Subtitle Label Constraints
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }

    
    func configure(title: String, subtitle: String, iconName : String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = UIImage(systemName: iconName)
    }
}
