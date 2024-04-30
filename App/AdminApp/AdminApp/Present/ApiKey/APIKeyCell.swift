//
//  APIKeyCell.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//
import UIKit

class APIKeyCell: UICollectionViewCell {
    
    static let identifier = "APIKeyCell"
    let colors: [UIColor] = [.Yellow600 , .Green600 , .LightBlue600, .systemRed]
    private let cellHeader = UIView()
    private let cellContent = UIView()
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "location.square.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .label
    }
    private let arrowImage = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.forward")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .label
    }
    private let cellTitleLabel = UILabel().then {
        $0.text = "Tracking API KEY"
        $0.font = .systemFont(ofSize: 20, weight: .bold, width: .standard)
        $0.textColor = .label
    }
    private let keyTitleLabel = UILabel().then {
        $0.text = "API KEY"
        $0.font = .systemFont(ofSize: 13, weight: .semibold, width: .standard)
        $0.textColor = .label
    }
    private let keyLabel = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 17, weight: .regular, width: .standard)
        $0.numberOfLines = 1
        $0.textColor = .label
    }
    private let gradeLabel = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 30, weight: .bold, width: .standard)
        $0.textColor = .label
    }
    private let createDateTitleLabel = UILabel().then {
        $0.text = "구매일"
        $0.font = .systemFont(ofSize: 13, weight: .semibold, width: .standard)
        $0.textColor = .label
    }
    private let createDateLabel = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 17, weight: .regular, width: .standard)
        $0.textColor = .label
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
        self.layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        self.backgroundColor = .defaultCellColor
        contentView.addSubview(cellHeader)
        contentView.addSubview(cellContent)
        
        
        
        [iconImageView,cellTitleLabel,arrowImage].forEach {
            cellHeader.addSubview($0)
        }
        [keyTitleLabel,keyLabel,gradeLabel,createDateLabel,createDateTitleLabel].forEach{
            cellContent.addSubview($0)
        }
        cellHeader.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        cellContent.snp.makeConstraints { make in
            make.top.equalTo(cellHeader.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(140)
        }
        
        //header
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        cellTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        arrowImage.snp.makeConstraints {
            $0.centerY.equalTo(cellTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        keyTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(gradeLabel.snp.bottom).offset(40)
        }
        
        keyLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(keyTitleLabel)
            make.width.equalTo(100)
        }
        
        createDateTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(keyLabel.snp.bottom).offset(10)
        }
        
        createDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(createDateTitleLabel)
        }
        
    }
    
    func configure(_ item: APICard) {
        keyLabel.text = item.value
        gradeLabel.text = item.grade
        switch item.grade {
        case "GRADE_FREE":
            self.iconImageView.tintColor = colors[0]
            self.cellTitleLabel.textColor = colors[0]
            self.arrowImage.tintColor = colors[0]
            self.gradeLabel.text = "FREE KEY"
        case "GRADE_CLASSIC":
            self.iconImageView.tintColor = colors[1]
            self.cellTitleLabel.textColor  = colors[1]
            self.arrowImage.tintColor = colors[1]
            self.gradeLabel.text = "CLASSIC KEY"
        case "GRADE_PRIMIUM":
            self.iconImageView.tintColor = colors[2]
            self.cellTitleLabel.textColor  = colors[2]
            self.arrowImage.tintColor = colors[2]
            self.gradeLabel.text = "PRIMIUM KEY"
        default:
            break
        }
        createDateLabel.text = item.createdAt
    }
}

extension APIKeyCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateShrinkDown()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateReturnToOriginalSize()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateReturnToOriginalSize()
    }
    
    private func animateShrinkDown() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func animateReturnToOriginalSize() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}
