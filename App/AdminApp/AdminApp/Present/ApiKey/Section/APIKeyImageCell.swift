import UIKit
import SnapKit
import Then

class APIKeyImageCell: UICollectionViewCell {
    static let identifier = "APIKeyImageCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.numberOfLines = 1
        $0.textColor = .label
    }
    
    private let idLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    
    private var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
        $0.textAlignment = .center
    }
    
    private var statusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .label
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
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.clipsToBounds = true
        $0.dropShadow(color: .systemGray, offSet: CGSize(width: 2, height: 2), opacity: 2, radius: 5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [titleLabel, idLabel,imageView,dateLabel,statusLabel,paymentStatusLabel, paymentStatusIcon, cardStatusLabel, cardStatusIcon].forEach {
            contentView.addSubview($0)
        }
        
        self.backgroundColor = .whiteBlackBackgroundColor
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(170)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(imageView.snp.leading).offset(-20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(imageView)
        }
        
        idLabel.snp.makeConstraints{
            $0.leading.equalTo(titleLabel.snp.trailing).offset(3)
            $0.centerY.equalTo(titleLabel)
        }
        statusLabel.snp.makeConstraints{
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        paymentStatusLabel.snp.makeConstraints {
            $0.top.equalTo(self.statusLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        paymentStatusIcon.snp.makeConstraints {
            $0.leading.equalTo(self.paymentStatusLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(self.paymentStatusLabel)
            $0.width.height.equalTo(16)
        }
        
        cardStatusLabel.snp.makeConstraints {
            $0.top.equalTo(self.paymentStatusLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.paymentStatusLabel)
        }

        cardStatusIcon.snp.makeConstraints {
            $0.leading.equalTo(self.cardStatusLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(self.cardStatusLabel)
            $0.width.height.equalTo(16)
        }
        
        
        
        
    }
    
    func configure(_ item: APICard) {
        titleLabel.text = determineTitleName(for: item.grade)
        imageView.image = UIImage(named: determineImageName(for: item.grade))
        idLabel.text = "#00\(item.id)"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = inputFormatter.date(from: item.createdAt) {
            let formattedDate = outputFormatter.string(from: date)
            dateLabel.text = "\(formattedDate) 생성 됨"
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
