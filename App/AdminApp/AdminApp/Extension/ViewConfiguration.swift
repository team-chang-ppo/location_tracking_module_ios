//
//  ViewConfiguration.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//

import Foundation

protocol ViewConfiguration {
    func buildHierarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewConfiguration {
    func configureViews() {}
    
    func SetupUI() {
        buildHierarchy()  // view.addSubviews()
        setupConstraints() // constraint
        configureViews() // dataSource
    }
}
