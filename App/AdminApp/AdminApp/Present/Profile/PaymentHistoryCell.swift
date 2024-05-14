//
//  PaymentHistoryCell.swift
//  AdminApp
//
//  Created by 승재 on 5/14/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

class PaymentHistoryCell: UICollectionViewCell {
    static let identifier = "PaymentHistoryCell"
    
    private let cardImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.image = UIImage(named: "payment_icon_yellow_small")
        
    }
    
    private let cardNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .label
    }
    
    private var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    
    private let amountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .label
        $0.textAlignment = .right
    }
    
    private let statusLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .right
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
//        contentView.makeRounded(cornerRadius: 16)
//        contentView.backgroundColor = .defaultCellColor
        
        [cardImageView, cardNameLabel, amountLabel, dateLabel,statusLabel].forEach{
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
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.cardNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.cardNameLabel)
        }
        
        amountLabel.snp.makeConstraints {
            $0.centerY.equalTo(cardNameLabel.snp.centerY)
            $0.trailing.equalTo(contentView).offset(-20)
        }
        statusLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.trailing.equalTo(contentView).offset(-20)
        }
        
    }
    
    func configure(_ item: PaymentHistory){
        cardNameLabel.text = item.cardInfo.issuerCorporation
        dateLabel.text = item.formattedDateRange()
        if item.status == "COMPLETED_PAID"{
            statusLabel.text = "결제완료"
            statusLabel.textColor = .systemBlue
        }
        else{
            statusLabel.text = "결재실패"
            statusLabel.textColor = .systemRed
        }
        amountLabel.text = "-\(item.amount)원"
        
        
        
    }
}
