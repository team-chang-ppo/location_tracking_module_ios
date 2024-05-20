//
//  HomeViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/18/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.register(CustomCollectionViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionViewCellHeader.identifier)
        $0.register(HomePagingItemCell.self, forCellWithReuseIdentifier: HomePagingItemCell.identifier)
        $0.showsVerticalScrollIndicator = false
        
    }
    var viewModel : HomeViewModel!
    
    enum Section : CaseIterable{
        case PaingItemList
        var title : String{
            switch self{
            case .PaingItemList: return "빠른 메뉴"
            }
        }
        var subtitle : String{
            switch self{
            case .PaingItemList: return "위치 추적 기능을 프로젝트에 적용할 수 있어요 !"
            }
        }
        var iconName : String{
            switch self{
            case .PaingItemList: return "map.fill"
            }
        }
    }
    
    enum Item: Hashable {
        case pagingItem(PagingItem)
    }
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var subScriptions = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(pageItem: PagingItem.list)
        configureCollectionView()
        setupUI()
        bind()
    }
    
    private func setupUI(){
        self.navigationItem.title = "Tracking API"
        self.tabBarItem.title = "홈"
        self.view.backgroundColor = .defaultBackgroundColor
    }
    private func bind() {
        viewModel.pageItem
            .receive(on: RunLoop.main)
            .sink { [unowned self] list in
                let sectionItems = list.map { Item.pagingItem($0) }
                self.applySectionItems(sectionItems, to: .PaingItemList)
            }.store(in: &subScriptions)
        viewModel.selectedPageItem
            .receive(on: RunLoop.main)
            .compactMap {$0}
            .sink { [unowned self] item in
                let vc: UIViewController
                switch item?.content {
                case .costPage:
                    vc = AnalzyeAPIViewController()
                    navigationController?.pushViewController(vc, animated: true)
                case .registerCardPage:
                    let registerVC = RegisterCardViewController()
                    let registerVM = RegisterCardViewModel()
                    registerVC.viewModel = registerVM
                    vc = registerVC
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium()]
                    }
                    present(vc, animated: true, completion: nil)
                case .purchaseAPIKeyPage:
                    vc = PurchaseViewController()
                    present(vc, animated: true, completion: nil)
                case .some(.analyzeAPI):
                    vc = PaymentHistoryViewController()
                    navigationController?.pushViewController(vc, animated: true)
                case .some(.guide):
                    let webVC = CommonWebViewController()
                    webVC.url = URL(string: "https://github.com/team-chang-ppo/location_tracking_module")
                    vc = webVC
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.large()]
                    }
                    present(vc, animated: true, completion: nil)
                case .none:
                    return
                }
                
                
                
            }.store(in: &subScriptions)
        
    }
    
    private func applySectionItems(_ items: [Item], to section: Section) {
        var snapshot = dataSource.snapshot()
        
        // 기존 섹션의 아이템을 모두 삭제
        if snapshot.sectionIdentifiers.contains(section) {
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        }
        
        // 새로운 섹션과 아이템 추가
        if !snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendSections([section])
        }
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .pagingItem(let pagingItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePagingItemCell.identifier, for: indexPath) as! HomePagingItemCell
                cell.configure(pagingItem)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionViewCellHeader.identifier, for: indexPath) as? CustomCollectionViewCellHeader else{
                return nil
            }
            let allSections = Section.allCases
            let section = allSections[indexPath.section]
            header.configure(title: section.title, subtitle: section.subtitle, iconName: section.iconName)
            return header
        }
        
    }
    
    
    private func mainLayoutSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 30
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [itemLayout])
        groupLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
//        groupLayout.interItemSpacing = .fixed(spacing+20)
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
        section.interGroupSpacing = spacing
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .PaingItemList:
                return self.mainLayoutSection()
            }
        }
    }
    
}



extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
        case .PaingItemList:
            viewModel.didPageSelect(at: indexPath)
        }
    }
}

