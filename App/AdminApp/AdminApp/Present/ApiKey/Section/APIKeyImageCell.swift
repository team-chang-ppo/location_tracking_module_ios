import UIKit
import SnapKit
import Then

class APIKeyImageCell: UICollectionViewCell {
    static let identifier = "APIKeyImageCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 1
        $0.textColor = .label
    }
    
    private var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    
    private var valueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
        $0.numberOfLines = 1
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.clipsToBounds = true
        $0.dropShadow(color: .systemGray, offSet: CGSize(width: 2, height: 2), opacity: 2, radius: 5)
    }
    
    private let roleImage = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.shield.fill")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(roleImage)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(valueLabel)
        
        self.backgroundColor = .whiteBlackBackgroundColor
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(170)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(imageView.snp.leading)
        }
        roleImage.snp.makeConstraints { make in
            make.trailing.equalTo(titleLabel.snp.leading).offset(-5)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(100)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(3)
            make.leading.equalTo(titleLabel)
        }
        
    }
    
    func configure(_ item: APICard) {
        titleLabel.text = determineTitleName(for: item.grade)
        valueLabel.text = "\(item.value)"
        imageView.image = UIImage(named: determineImageName(for: item.grade))
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
            descriptionLabel.text = formattedDate
        } else {
            descriptionLabel.text = "N/A"
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
