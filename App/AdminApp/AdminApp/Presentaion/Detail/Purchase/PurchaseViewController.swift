//
//  PurchaseViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import UIKit
struct PurchaseInfo: Hashable {
    let title: String
    let description: String
    let imageName: String
}

extension PurchaseInfo {
    static let list = [
        PurchaseInfo(title: "Free Key", description: "일정 사용량을 무료로 사용할 수 있습니다.", imageName: "img_free_map"),
        PurchaseInfo(title: "Classic Key", description: "월간 API를 호출한 사용량에 따라 후불 청구됩니다.", imageName: "img_classic_map"),
        PurchaseInfo(title: "Primium Key", description: "프로 개발자 및 팀의 개발에 적합합니다.", imageName: "img_primium_map"),
        
    ]
}

class PurchaseViewController: UIViewController {
    
    private var titleLabel =
    UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        $0.textAlignment = .center
        $0.text = "API KEY 구매"
    }
    private var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        
        // 텍스트 생성
        let text = """
            원하는 API KEY를 구매할 수 있어요 !
            월간 정기결제로 자동으로 결제됩니다.
            """
        let attributedText = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        $0.attributedText = attributedText
        
        $0.textAlignment = .center
    }
    
    private var purchaseButton = UIButton(type: .system).then {
        $0.setTitle("API KEY 구매하기", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 25
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.register(PurchaseCell.self, forCellWithReuseIdentifier: PurchaseCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = false
        
    }
    private var pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .darkGray
        $0.pageIndicatorTintColor = .lightGray
    }
    
    let bannerInfos: [PurchaseInfo] = PurchaseInfo.list
    let colors: [UIColor] = [.Yellow600 , .Green600 , .LightBlue600, .systemRed]
    typealias Item = PurchaseInfo
    var datasource : UICollectionViewDiffableDataSource<Section , Item>!
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupLayout()
        
        datasource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PurchaseCell.identifier, for: indexPath) as? PurchaseCell else{
                return nil
            }
            cell.configure(item)
            cell.backgroundColor = self.colors[indexPath.item]
            return cell
            
        })
        
        // data : snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bannerInfos, toSection: .main)
        datasource.apply(snapshot)
        
        pageControl.numberOfPages = bannerInfos.count
        
    }
    private func setupUI() {
        purchaseButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        [titleLabel, descriptionLabel, collectionView,pageControl, purchaseButton].forEach(view.addSubview)
    }
    private func setupLayout(){
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.height.equalTo(200)
            $0.width.equalTo(view.snp.width)
        }
        pageControl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(5)
            $0.height.equalTo(30)
        }
        
        purchaseButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
    }
    private func layout() -> UICollectionViewCompositionalLayout{
        
        let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemsize)
        let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20
        section.visibleItemsInvalidationHandler = { (item, offset, env) in
            let index = Int((offset.x/env.container.contentSize.width).rounded(.up))
            self.pageControl.currentPage = index
            
            
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        return layout
        
    }
    
    @objc func purchaseButtonTapped(){
        
    }
    
}

extension PurchaseViewController: UICollectionViewDelegate{
    
}