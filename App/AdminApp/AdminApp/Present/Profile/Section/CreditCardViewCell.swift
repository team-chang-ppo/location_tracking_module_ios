//
//  CreditCardViewCell.swift
//  AdminApp
//
//  Created by 승재 on 4/29/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

class CreditCardViewCell: UICollectionViewCell {
    static let identifier = "CreditCardViewCell"
    
    private let cardImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.image = UIImage(named: "payment_icon_yellow_small")
        
    }
    
    private let cardNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .label
    }
    
    private var cardMessageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    private let arrowImage = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.forward")
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
        
        [cardImageView, cardNameLabel, cardMessageLabel,arrowImage].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        cardImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalToSuperview().offset(8)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        
        cardNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(self.cardImageView.snp.trailing).offset(11)
        }
        
        cardMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.cardNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.cardNameLabel)
        }
        arrowImage.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView).offset(-20)
        }
    }
    
    func configure(item: Card?){
        cardNameLabel.text = item?.issuerCorporation
        cardMessageLabel.text = item?.bin
    }
}
