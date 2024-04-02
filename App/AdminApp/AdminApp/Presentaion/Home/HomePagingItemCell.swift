//
//  InfoCell.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import UIKit

// 결제 정보를 Present 할 Cell
// 처음 UI는 지금까지 사용한 요금 크게 보여주면될거같음

class HomePagingItemCell: UICollectionViewCell {
    static let identifier = "HomePagingItemCell"
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false // 이미지 뷰에 대해 오토레이아웃 사용 설정
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .regular)
        descriptionLabel.numberOfLines = 0 // 여러 줄 표시
        
        // 뷰에 추가
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        // 오토레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    
    func configure(_ item: PagingItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        iconImageView.image = UIImage(systemName: item.iconName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        switch item.color{
        case .red:
            self.backgroundColor = .systemPink
            self.titleLabel.textColor = .white
            self.descriptionLabel.textColor = .white
        case .gray:
            self.backgroundColor = .darkGray
            self.titleLabel.textColor = .white
            self.descriptionLabel.textColor = .white
        case .blue:
            self.backgroundColor = .systemBlue
            self.titleLabel.textColor = .white
            self.descriptionLabel.textColor = .white
        case .green:
            self.backgroundColor = .systemGreen
            self.titleLabel.textColor = .white
            self.descriptionLabel.textColor = .white
        }
        
    }
}

