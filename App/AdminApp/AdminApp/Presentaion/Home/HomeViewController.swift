//
//  HomeViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/18/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var viewModel : HomeViewModel!
    
    enum Section : CaseIterable{
        case PaingItemList
        case APIKeyList
        
        var title : String{
            switch self{
            case .PaingItemList: return "Location Tracking"
            case .APIKeyList: return "내 API KEY"
            }
        }
        var subtitle : String{
            switch self{
            case .PaingItemList: return "위치 추적 기능을 프로젝트에 적용할 수 있어요 !"
            case .APIKeyList: return "소유한 API KEY의 통계를 볼 수 있어요 !"
            }
        }
        var iconName : String{
            switch self{
            case .PaingItemList: return "map.fill"
            case .APIKeyList: return "location.fill"
            }
        }
    }
    enum Item: Hashable {
        case pagingItem(PagingItem)
        case apiKey(APICard)
    }
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    
    // Combine
    var subscriptions = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        viewModel = HomeViewModel(pageItem: PagingItem.list, APIItem: APICard.list)
        configureNavigationItem()
        SetUI()
        configureCollectionView()
        bind()
    }
    
    private func SetUI(){
        
    }
    private func bind() {
        // input: 사용자 인풋을 받아서, 처리해야할것
        // - item 선택 되었을때 처리
        // output: data, state 변경에 따라서, UI 업데이트 할것
        // - items 세팅이 되었을때 컬렉션뷰를 업데이트
        viewModel.pageItem
                .receive(on: RunLoop.main)
                .sink { [unowned self] list in
                    let sectionItems = list.map { Item.pagingItem($0) }
                    self.applySectionItems(sectionItems, to: .PaingItemList)
                }.store(in: &subscriptions)
        viewModel.selectedPageItem
            .compactMap {$0}
            .receive(on: RunLoop.main)
            .sink { [unowned self] item in
                let vc: UIViewController
                switch item?.content {
                case .costPage:
                    vc = CostViewController()
                case .registerCardPage:
                    vc = RegisterCardViewController()
                case .PurchaseAPIKeyPage:
                    vc = PurchaseViewController()
                case .none:
                    return
                }

                // SheetPresentationController 설정
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(vc, animated: true, completion: nil)
            }.store(in: &subscriptions)
        viewModel.APIItem
                .receive(on: RunLoop.main)
                .sink { [unowned self] list in
                    let sectionItems = list.map { Item.apiKey($0) }
                    self.applySectionItems(sectionItems, to: .APIKeyList)
                }.store(in: &subscriptions)
        viewModel.selectedAPIItem
            .compactMap{ $0 }
            .receive(on: RunLoop.main)
            .sink { item in
                let vc = APIDetailViewController()
                //                vc.viewModel = FrameworkDetailViewModel(framework: framework)
                vc.modalPresentationStyle = .pageSheet
                self.present(vc,animated: true)
                
            }.store(in: &subscriptions)
        
        
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
        // collectionView 초기화 및 설정
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        // Auto Layout 제약 조건 설정
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // dataSource 설정
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .pagingItem(let pagingItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePagingItemCell.identifier, for: indexPath) as! HomePagingItemCell
                cell.configure(pagingItem)
                return cell
            case .apiKey(let apiCard):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAPIKeyCell.identifier, for: indexPath) as! HomeAPIKeyCell
                cell.configure(apiCard)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionViewCellHeader.identifier, for: indexPath) as? HomeCollectionViewCellHeader else{
                return nil
            }
            let allSections = Section.allCases
            let section = allSections[indexPath.section]
            header.configure(title: section.title, subtitle: section.subtitle, iconName: section.iconName)
            return header
        }
        
        collectionView.delegate = self
        collectionView.register(HomeAPIKeyCell.self, forCellWithReuseIdentifier: HomeAPIKeyCell.identifier) // 셀 등록
        collectionView.register(HomeCollectionViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionViewCellHeader.identifier)
        collectionView.register(HomePagingItemCell.self, forCellWithReuseIdentifier: HomePagingItemCell.identifier)
            
        // layer
        collectionView.collectionViewLayout = layout()
        
        collectionView.delegate = self
    }
    
    
    private func horizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(170))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        itemLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(170))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: itemLayout, count: 1)
        
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func mainSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: itemLayout, count: 1)
        groupLayout.interItemSpacing = .fixed(spacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16)
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
                return self.horizontalSection()
            case .APIKeyList:
                return self.mainSection()
            }
        }
    }
    
}



extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
        case .PaingItemList:
            viewModel.didPageSelect(at: indexPath)
        case .APIKeyList:
            viewModel.didAPISelect(at: indexPath)
        }
    }
}

extension HomeViewController {
    private func configureNavigationItem() {
        let profileImage = UIImage(systemName: "person.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        let profileButton = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfileButton))
        self.navigationItem.rightBarButtonItem = profileButton
    }
    
    @objc func didTapProfileButton() {
        KeychainManager.delete(key: "SessionID")
        let vc = ProfileViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
