//
//  ProfileViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//

import UIKit
import Kingfisher
import SnapKit
import Combine

class ProfileViewController: UIViewController {
    
    private var viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        viewModel.fetchUserData()
        viewModel.fetchCardList()
        
    }

    private func setupUI() {
        self.navigationItem.title = "내 정보"
        self.tabBarItem.title = "내 정보"
        self.view.backgroundColor = .systemBackground
        
    
    }
    

    private func bind() {
        
    }
    
}

