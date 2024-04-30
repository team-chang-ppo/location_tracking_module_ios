//
//  APIKeyHeaderView.swift
//  AdminApp
//
//  Created by 승재 on 3/20/24.
//

import UIKit

class APIKeyHeaderView: UICollectionViewCell {
    let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(titleLabel)
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(_ title: String) {
            titleLabel.text = title
        }
}
