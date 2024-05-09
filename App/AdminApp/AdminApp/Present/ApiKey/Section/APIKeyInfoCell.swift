//
//  APIKeyInfoCell.swift
//  AdminApp
//
//  Created by 승재 on 5/7/24.
//


import UIKit
import Kingfisher
import SnapKit
import Then

class APIKeyInfoCell: UICollectionViewCell {
    static let identifier = "APIKeyInfoCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .label
    }
    private let arrowImage = UIImageView().then {
        
        $0.tintColor = .Grey400
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        contentView.makeRounded(cornerRadius: 16)
        contentView.backgroundColor = .defaultCellColor
        
        [titleLabel,arrowImage].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        arrowImage.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalTo(contentView).offset(-20)
        }
    }
    
    func configure(_ item: APIKeyItem){
        titleLabel.text = item.title
        switch item.content{
            
        case .copyPasteAPIKey:
            arrowImage.image = UIImage(systemName: "doc.on.doc")
        case .analyzeAPIKey:
            arrowImage.image = UIImage(systemName: "arrow.forward")
        case .deleteAPIKey:
            arrowImage.image = UIImage(systemName: "trash")
        }
        
    }
}
