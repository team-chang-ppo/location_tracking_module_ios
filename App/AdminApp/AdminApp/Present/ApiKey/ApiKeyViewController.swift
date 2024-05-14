//
//  ApiKeyViewController.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//
import UIKit
import Combine
import Then

class ApiKeyViewController: UIViewController, UICollectionViewDelegate {
    var isInfiniteScroll = true
    
    var buttonConfig = UIButton.Configuration.plain()
    lazy var purchaseCardButton = UIButton(configuration: buttonConfig).then{
        $0.tintColor = .LightBlue700
        $0.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.register(APIKeyListCell.self, forCellWithReuseIdentifier: APIKeyListCell.identifier)
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        //        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        
    }
    
    enum Item: Hashable {
        case cardList(APICard)
    }
    
    var dataSource : UICollectionViewDiffableDataSource<Section , Item>!
    enum Section : Int, CaseIterable {
        case cardSection
    }
    
    private var viewModel = APIKeyViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupDatasource()
        setupRefreshControl()
        bind()
//        viewModel.fetchAPIKeys(firstApiKeyId: 1, size: 5)
    }
    private func bind() {
        viewModel.apiKey
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink(receiveCompletion: { error in
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                }

                switch error {
                case .finished:
                    break
                case .failure(let error):
                    switch error{
                        
                    case .encodingFailed:
                        self.showConfirmationPopup(mainText: "네트워크 오류", subText: "API KEY를 받아올 수 없습니다.\nEncodingFailed", centerButtonTitle: "확인")
                    case .networkFailure(let code):
                        self.showConfirmationPopup(mainText: "네트워크 오류", subText: "API KEY를 받아올 수 없습니다.\n\(code) NetworkFailture ", centerButtonTitle: "확인")
                    case .invalidResponse:
                        self.showConfirmationPopup(mainText: "네트워크 오류", subText: "API KEY를 받아올 수 없습니다.\ninvalidResponse", centerButtonTitle: "확인")
                    case .unknown:
                        self.showConfirmationPopup(mainText: "네트워크 오류", subText: "API KEY를 받아올 수 없습니다.\n알수없는 에러", centerButtonTitle: "확인")
                    }
                    
                }
            }, receiveValue: {  [weak self] apiKeyData in
                DispatchQueue.main.async {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
                let items = apiKeyData.compactMap{ $0 }
                let temp = items.map{ Item.cardList($0) }
                self?.applySectionItems(temp, to: .cardSection)
            })
            .store(in: &subscriptions)
        
        viewModel.selectedApiKey
            .receive(on: RunLoop.main)
            .compactMap{$0}
            .sink { [unowned self] item in
                
                let vc = APIKeyDetailViewController()
                vc.viewModel = APIKeyDetailViewModel(ApiKeyItem: APIKeyItem.list, apiKey: item)
                vc.completionHandler = { [weak self] completion in
                    if completion {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            self?.viewModel.refreshing()
                        }
                    }
                }
                
                navigationController?.pushViewController(vc,animated: true)
                
            }
            .store(in: &subscriptions)
        
        

        
    }
    private func setupDatasource(){
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item{
            case .cardList(let card):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: APIKeyListCell.identifier, for: indexPath) as! APIKeyListCell
                cell.configure(card)
                return cell
            }
        })
    }
    private func applySectionItems(_ items: [Item], to section: Section) {
        var snapshot = dataSource.snapshot()
        
        if snapshot.sectionIdentifiers.contains(section) {
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        }
        
        if !snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendSections([section])
        }
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupUI() {
        self.title = "API 키"
        self.navigationItem.title = "내 API 키"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: purchaseCardButton)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .defaultBackgroundColor
        purchaseCardButton.addTarget(self, action: #selector(didTapPurchase), for: .touchUpInside)
    }
    
    private func setupLayout(){
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func didTapPurchase() {
        let vc = PurchaseViewController()
        vc.completionHandler = { [weak self] completion in
            if completion {
                self?.viewModel.refreshing()
            }
        }
        vc.modalPresentationStyle = .pageSheet
        self.present(vc,animated: true)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { sectionIndex , layoutEnviroment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .cardSection:
                return self.cardSectionLayout()
            }
        }
    }
    
    private func cardSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // 스크롤링 중 셀 변환 적용
        section.visibleItemsInvalidationHandler = { visibleItems, offset, environment in
            let cellItems = visibleItems.filter { $0.representedElementKind != UICollectionView.elementKindSectionHeader }
            let containerHeight = environment.container.contentSize.height // 컨테이너 높이 사용

            cellItems.forEach { item in
                let itemCenterRelativeToOffset = item.frame.midY - offset.y // y축 중심 계산
                let distanceFromCenter = abs(itemCenterRelativeToOffset - containerHeight / 2.0) // 세로 중앙에서의 거리 계산

                // 스케일 계산: 컨테이너 높이를 기준으로 중앙에서 멀어질수록 스케일 감소
                let minScale: CGFloat = 0.9 // 최소 스케일
                let maxScale: CGFloat = 1.0 // 최대 스케일
                let scale = max(maxScale - (distanceFromCenter / containerHeight), minScale) // 거리에 따라 스케일 계산

                item.transform = CGAffineTransform(scaleX: scale, y: scale) // 변환 적용
            }
        }
        return section
    }
    
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAPIKeys), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshAPIKeys() {
        viewModel.refreshing()
    }
    
    
}

extension ApiKeyViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section]{
        case .cardSection:
            viewModel.didPageSelect(at: indexPath)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height) && isInfiniteScroll {
            isInfiniteScroll = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.fetchAPIKeys(size: 5)
                self.isInfiniteScroll = true
            }
        }
    }
}
