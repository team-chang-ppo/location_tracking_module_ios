//
//  ApiKeyViewController.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit
import Combine
import Then

struct ApiFilterCellItem{
    let title : String
    let imageName : String
    
    static let list : [ApiFilterCellItem] = [
        ApiFilterCellItem(title: "전체", imageName: "line.3.horizontal.decrease.circle.fill"),
        ApiFilterCellItem(title: "Free", imageName: "key.fill"),
        ApiFilterCellItem(title: "Classic", imageName: "key.fill"),
        ApiFilterCellItem(title: "Premium", imageName: "key.fill"),
    ]
}

class ApiKeyViewController: UIViewController, UICollectionViewDelegate {
    
    var viewModel: APIKeyViewModel!
    var buttonConfig = UIButton.Configuration.plain()
    lazy var purchaseCardButton = UIButton(configuration: buttonConfig).then{
        $0.tintColor = .LightBlue700
        $0.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
    }
    private var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: 1, height: 40)
        $0.collectionViewLayout = layout
        $0.register(ApiFilterCell.self, forCellWithReuseIdentifier: ApiFilterCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    
    private var APIKeyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 16
        let width = UIScreen.main.bounds.width * 0.9
        layout.itemSize = CGSize(width: width, height: 210)
        layout.sectionInsetReference = .fromContentInset
        $0.collectionViewLayout = layout
        $0.register(APIKeyCell.self, forCellWithReuseIdentifier: APIKeyCell.identifier)
        $0.backgroundColor = .clear
        $0.decelerationRate = .fast
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupUI()
        setupCollectionView()
        viewModel.fetchAPIKeys(firstApiKeyId: 1, size: 5)
    }
    private func bind() {
        viewModel.APIItem
            .receive(on: RunLoop.main)
            .compactMap{$0}
            .sink { [weak self] _ in
                self?.APIKeyCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func setupUI(){
        self.title = "API 키 "
        self.navigationItem.title = "내 API 키"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: purchaseCardButton)
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        purchaseCardButton.addTarget(self, action: #selector(didTapPurchase), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        APIKeyCollectionView.delegate = self
        APIKeyCollectionView.dataSource = self
        
        view.addSubview(APIKeyCollectionView)
        view.addSubview(filterCollectionView)
        
        APIKeyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(purchaseCardButton)
        
        
        
    }
    @objc func didTapPurchase() {
        let vc = PurchaseViewController()
        vc.modalPresentationStyle = .pageSheet
        self.present(vc,animated: true)
    }
}

extension ApiKeyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return ApiFilterCellItem.list.count
        } else {
            return viewModel.APIItem.value?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApiFilterCell.identifier, for: indexPath) as! ApiFilterCell
            cell.configure(ApiFilterCellItem.list[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: APIKeyCell.identifier, for: indexPath) as! APIKeyCell
            if let apiCard = viewModel.APIItem.value?[indexPath.item] {
                
                
                cell.configure(apiCard)
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == filterCollectionView {
                print(indexPath.item)
            }else{
                print(indexPath.item)
            }
        }
}
