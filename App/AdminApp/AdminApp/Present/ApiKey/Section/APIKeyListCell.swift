//
//  APIKeyListCell.swift
//  AdminApp
//
//  Created by 승재 on 5/9/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

class APIKeyListCell: UICollectionViewCell {
    static let identifier = "APIKeyListCell"
    
    private let cardImageView = UIImageView().then {
        $0.makeRounded(cornerRadius: 4)
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .label
    }
    
    private var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    
    private var valueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
        $0.numberOfLines = 1
    }
    
    private let roleImage = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.shield.fill")
    }
    
    private let iconImage = UIImageView().then {
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
        contentView.backgroundColor = .defaultCellColor
        contentView.makeRounded(cornerRadius: 10)
        contentView.dropShadow(color: .Grey800, offSet: CGSize(width: 2, height: 2), opacity: 0.2, radius: 16)
        [cardImageView, titleLabel,dateLabel, valueLabel,iconImage,roleImage].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        cardImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalTo(55)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(self.cardImageView.snp.trailing).offset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.titleLabel)
        }
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.dateLabel)
            $0.width.equalTo(200)
        }
        roleImage.snp.makeConstraints{
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(self.titleLabel.snp.centerY)
        }
        
        iconImage.snp.makeConstraints{
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
    
    func configure(_ item: APICard) {
        cardImageView.image = UIImage(named: determineImageName(for: item.grade))
        titleLabel.text = determineTitleName(for: item.grade)
        valueLabel.text = item.value
        if item.grade == "GRADE_FREE"{
            roleImage.tintColor = .Grey400
        }else{
            roleImage.tintColor = .systemBlue
        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputFormatter.date(from: item.createdAt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy/MM/dd"
            
            let formattedDate = outputFormatter.string(from: date)
            dateLabel.text = formattedDate
        } else {
            dateLabel.text = "N/A"
        }
    }
    private func determineImageName(for grade: String) -> String {
        switch grade {
        case "GRADE_FREE":
            return "free_api_key"
        case "GRADE_CLASSIC":
            return "classic_api_key"
        case "GRADE_PREMIUM":
            return "premium_api_key"
        default:
            return "default_api_key"
        }
    }
    private func determineTitleName(for grade: String) -> String {
        switch grade {
        case "GRADE_FREE":
            return "FREE KEY"
        case "GRADE_CLASSIC":
            return "CLASSIC KEY"
        case "GRADE_PREMIUM":
            return "PREMIUM KEY"
        default:
            return ""
        }
    }
}
