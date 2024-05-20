import UIKit
import Kingfisher
import SnapKit
import Then

class APIKeyListCell: UICollectionViewCell {
    static let identifier = "APIKeyListCell"
    
    private let cardImageView = UIImageView().then {
        $0.makeRounded(cornerRadius: 6)
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .label
    }
    
    private let idLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    
    private var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    
    private var statusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
        $0.text = "API 상태"
    }
    
    private var paymentStatusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    private var cardStatusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private let paymentStatusIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let cardStatusIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let actionButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        $0.tintColor = .systemGray
        $0.contentMode = .scaleAspectFit
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
        [cardImageView, titleLabel, idLabel, dateLabel, statusLabel, paymentStatusIcon, paymentStatusLabel, cardStatusIcon, cardStatusLabel, actionButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        cardImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalTo(65)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(self.cardImageView.snp.trailing).offset(20)
        }
        
        idLabel.snp.makeConstraints{
            $0.leading.equalTo(titleLabel.snp.trailing).offset(3)
            $0.centerY.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.titleLabel)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.titleLabel)
        }
        
        paymentStatusIcon.snp.makeConstraints {
            $0.top.equalTo(self.statusLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.statusLabel)
            $0.width.height.equalTo(16)
        }
        
        paymentStatusLabel.snp.makeConstraints {
            $0.leading.equalTo(self.paymentStatusIcon.snp.trailing).offset(5)
            $0.centerY.equalTo(self.paymentStatusIcon)
        }
        
        cardStatusIcon.snp.makeConstraints {
            $0.top.equalTo(self.paymentStatusIcon.snp.bottom).offset(3)
            $0.leading.equalTo(self.statusLabel)
            $0.width.height.equalTo(16)
        }
        
        cardStatusLabel.snp.makeConstraints {
            $0.leading.equalTo(self.cardStatusIcon.snp.trailing).offset(5)
            $0.centerY.equalTo(self.cardStatusIcon)
        }

        actionButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-8)
            $0.height.width.equalTo(30)
        }
    }
    
    func configure(_ item: APICard) {
        cardImageView.image = UIImage(named: determineImageName(for: item.grade))
        titleLabel.text = determineTitleName(for: item.grade)
        idLabel.text = "#00\(item.id)"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputFormatter.date(from: item.createdAt) {
            let daysAgo = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
            if daysAgo == 0 {
                dateLabel.text = "오늘 생성됨"
            }
            else if daysAgo < 30 {
                dateLabel.text = "\(daysAgo)일 전 생성됨"
            } else {
                let monthsAgo = daysAgo / 30
                dateLabel.text = "\(monthsAgo)달 전 생성됨"
            }
        } else {
            dateLabel.text = "N/A"
        }
        
        let paymentAvailable = (item.paymentFailureBannedAt == nil || item.cardDeletionBannedAt == "null")
        paymentStatusLabel.text = paymentAvailable ? "현재 사용 가능" : "중지 됨"
        paymentStatusLabel.textColor = paymentAvailable ? .LightBlue500 : .systemRed
        paymentStatusIcon.image = UIImage(systemName: paymentAvailable ? "checkmark.circle" : "xmark.circle")
        paymentStatusIcon.tintColor = paymentAvailable ? .LightBlue500 : .systemRed
        
        if item.grade != "GRADE_FREE"{
            let cardRegistered = (item.cardDeletionBannedAt == nil || item.cardDeletionBannedAt == "null")
            cardStatusLabel.text = cardRegistered ? "결제 카드 등록됨" : "결제 카드가 등록되어있지 않습니다."
            cardStatusLabel.textColor = cardRegistered ? .LightBlue600 : .systemRed
            cardStatusIcon.image = UIImage(systemName: cardRegistered ? "checkmark.circle" : "xmark.circle")
            cardStatusIcon.tintColor = cardRegistered ? .LightBlue600 : .systemRed
        }else{
            let cardRegistered = (item.cardDeletionBannedAt == nil || item.cardDeletionBannedAt == "null")
            cardStatusLabel.text = cardRegistered ? "API 속도 제한적용" : "결제 카드가 등록되어있지 않습니다."
            cardStatusLabel.textColor = cardRegistered ? .Yellow600 : .systemRed
            cardStatusIcon.image = UIImage(systemName: cardRegistered ? "checkmark.circle" : "xmark.circle")
            cardStatusIcon.tintColor = cardRegistered ? .Yellow600 : .systemRed
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
