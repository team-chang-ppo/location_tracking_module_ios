//
//  ProfileViewCell.swift
//  AdminApp
//
//  Created by 승재 on 4/29/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

class ProfileViewCell: UICollectionViewCell {
    static let identifier = "ProfileViewCell"
    
    private let profileImageView = UIImageView().then {
        $0.makeRounded(cornerRadius: 16)
    }
    
    private let profileNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .label
    }
    
    private var profileMessageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor(hexCode: "#A6A6A6")
    }
    private let roleImage = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.shield.fill")
    }
    private let iconImage = UIImageView().then {
        $0.image = UIImage(systemName: "questionmark.circle.fill")
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
        
        [profileImageView, profileNameLabel, profileMessageLabel,iconImage,roleImage].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints(){
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalToSuperview().offset(8)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(11)
        }
        
        profileMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.profileNameLabel)
        }
        roleImage.snp.makeConstraints{
            $0.leading.equalTo(self.profileNameLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(self.profileNameLabel.snp.centerY)
        }
        
        iconImage.snp.makeConstraints{
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
    
    func configure(item: UserProfile?){
        let url = URL(string: item?.profileImage ?? "")
        profileImageView.kf.setImage(with: url)
        profileImageView.kf.indicatorType = .activity
        profileNameLabel.text = item?.username ?? "계정 정보가 없습니다."
        guard let roles = item?.role else { return }
        if roles == "ROLE_FREE"{
            profileMessageLabel.text = "FREE 등급"
            roleImage.tintColor = .Grey400
        }else if roles == "ROLE_NORMAL"{
            profileMessageLabel.text = "NORMAL 등급"
            roleImage.tintColor = .systemBlue
        }
        
    }
}
