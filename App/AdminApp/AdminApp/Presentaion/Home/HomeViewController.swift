//
//  HomeViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/18/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var collectionView : UICollectionView!
    var viewModel : HomeViewModel!
    
    enum Section : CaseIterable{
        case PaingItemList
        
        var title : String{
            switch self{
            case .PaingItemList: return "Location Tracking"
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
        self.view.backgroundColor = .systemBackground
        viewModel = HomeViewModel(pageItem: PagingItem.list)
        configureCollectionView()
        SetUI()
        bind()
    }
    
    private func SetUI(){
        self.view.backgroundColor = .systemBackground
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
            }.store(in: &subScriptions)
        viewModel.selectedPageItem
            .compactMap {$0}
            .receive(on: RunLoop.main)
            .sink { [unowned self] item in
                let vc: UIViewController
                switch item?.content {
                case .costPage:
                    vc = CostViewController()
                case .registerCardPage:
                    let registerVC = RegisterCardViewController()
                    let registerVM = RegisterCardViewModel()
                    registerVC.viewModel = registerVM
                    vc = registerVC
                case .purchaseAPIKeyPage:
                    vc = PurchaseViewController()
                case .some(.analyzeAPI):
                    return
                case .some(.guide):
                    return
                case .none:
                    return
                }
                
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(vc, animated: true, completion: nil)
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
        // collectionView 초기화 및 설정
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionViewCellHeader.identifier)
        collectionView.register(HomePagingItemCell.self, forCellWithReuseIdentifier: HomePagingItemCell.identifier)
        
        // dataSource 설정
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
        groupLayout.interItemSpacing = .fixed(spacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 32, trailing: 24)
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

