//
//  ApiKeyViewController.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit
import Combine

class ApiKeyViewController: UIViewController {
    
    var viewModel : APIKeyViewModel!
    
    var collectionView: UICollectionView!
    
    enum Section : CaseIterable{
        case APIKeyList
        
        var title : String{
            switch self{
            case .APIKeyList: return "내 API KEY"
            }
        }
        var subtitle : String{
            switch self{
            case .APIKeyList: return "소유한 API KEY의 통계를 볼 수 있어요 !"
            }
        }
        var iconName : String{
            switch self{
            case .APIKeyList: return "location.fill"
            }
        }
    }
    
    enum Item: Hashable {
        case apiKey(APICard)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var subScriptions = Set<AnyCancellable>()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "내 API KEY"
        configureCollectionView()
        bind()
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
    
    private func bind(){
        viewModel.APIItem
            .receive(on: RunLoop.main)
            .sink { [unowned self] list in
                let sectionItems = list.map { Item.apiKey($0) }
                self.applySectionItems(sectionItems, to: .APIKeyList)
            }.store(in: &subScriptions)
        viewModel.selectedAPIItem
            .compactMap{ $0 }
            .receive(on: RunLoop.main)
            .sink { item in
                let vc = AnalzyeAPIViewController()
                //                vc.viewModel = FrameworkDetailViewModel(framework: framework)
                vc.modalPresentationStyle = .pageSheet
                self.present(vc,animated: true)
                
            }.store(in: &subScriptions)
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
        
        // dataSource 설정
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .apiKey(let apiCard):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: APIKeyCell.identifier, for: indexPath) as! APIKeyCell
                cell.configure(apiCard)
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
        
        collectionView.delegate = self
        collectionView.register(APIKeyCell.self, forCellWithReuseIdentifier: APIKeyCell.identifier) // 셀 등록
        collectionView.register(CustomCollectionViewCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionViewCellHeader.identifier)
        collectionView.register(HomePagingItemCell.self, forCellWithReuseIdentifier: HomePagingItemCell.identifier)
            
        // layer
        collectionView.collectionViewLayout = layout()
        
        collectionView.delegate = self
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
            case .APIKeyList:
                return self.mainSection()
            }
        }
    }
    
    
}

extension ApiKeyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
        case .APIKeyList:
            viewModel.didAPISelect(at: indexPath)
        }
    }
}
