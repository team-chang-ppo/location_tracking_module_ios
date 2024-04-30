//
//  SmallFooter.swift
//  AdminApp
//
//  Created by 승재 on 4/29/24.
//

import Foundation
import UIKit
import Then

class SmallCellFooter: UICollectionReusableView {
    static let identifier = "SmallCellFooter"
    
    private let subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .Grey400
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func configure(subtitle: String) {
        subtitleLabel.text = subtitle
    }
}
