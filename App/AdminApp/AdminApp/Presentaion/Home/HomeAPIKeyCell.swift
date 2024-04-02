//
//  APIKeyCell.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//
import UIKit

class HomeAPIKeyCell: UICollectionViewCell {
    // UI 컴포넌트 선언
    static let identifier = "HomeAPIKeyCell"
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        
        self.backgroundColor = .systemPink
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0 // 여러 줄 표시
        
        // 뷰에 추가
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        // 오토레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // 셀에 데이터를 설정하는 함수
    func configure(_ item: APICard) {
        titleLabel.text = item.key
        descriptionLabel.text = Utils.dateToString(from: item.expirationDate, format: "yy/MM/dd")
    }
}

