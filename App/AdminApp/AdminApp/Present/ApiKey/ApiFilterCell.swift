//
//  ApiFilterCell.swift
//  AdminApp
//
//  Created by 승재 on 4/7/24.
//

import Foundation
import UIKit



class ApiFilterCell: UICollectionViewCell {
    
    static let identifier = "ApiFilterCell"
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .label
    }
    private let cellTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular, width: .standard)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.layer.cornerRadius = 13
        self.backgroundColor = .defaultCellColor
        
        
        [iconImageView,cellTitleLabel].forEach {
            self.addSubview($0)
        }
        
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }

        cellTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func configure(_ item: ApiFilterCellItem) {
        cellTitleLabel.text = item.title
        iconImageView.image = UIImage(systemName: item.imageName)
    }
}

extension ApiFilterCell {
    
}
