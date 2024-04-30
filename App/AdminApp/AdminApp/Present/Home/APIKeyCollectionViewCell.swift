//
//  APIKeyCollectionViewCell.swift
//  AdminApp
//
//  Created by 승재 on 3/20/24.
//

import UIKit

class APIKeyCollectionViewCell: UICollectionViewCell {
    func resetTransform() {
            transform = .identity
        }

        lazy var appContentView: AppContentView = {
            var view = AppContentView(isContentView: false)
            view.layer.cornerRadius = 20
            view.contentMode = .center
            return view
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.configureCellLayout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.configureCellLayout()
        }
        
        func configureCellLayout() {
            
            self.clipsToBounds = true
            self.layer.cornerRadius = 20
            
            contentView.addSubview(appContentView)
            
            appContentView.snp.makeConstraints { (const) in
                const.top.equalToSuperview()
                const.bottom.equalToSuperview()
                const.leading.equalToSuperview()
                const.trailing.equalToSuperview()
            }
        }
        
        func fectchData(model: AppContentModel) {
            appContentView.fetchDataForCell(image: model.image, subD: model.subDescription!, desc: model.description!)
        }
}
