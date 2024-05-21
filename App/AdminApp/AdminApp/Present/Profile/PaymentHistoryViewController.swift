//
//  PaymentHistoryViewController.swift
//  AdminApp
//
//  Created by 승재 on 5/14/24.
//

import UIKit
import Then
import SnapKit

import Combine

class PaymentHistoryViewController: UIViewController, UICollectionViewDelegate {
    
    var isInfiniteScroll = true
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.register(PaymentHistoryCell.self, forCellWithReuseIdentifier: PaymentHistoryCell.identifier)
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        
    }
    enum Section : CaseIterable {
        case main
    }
    enum Item: Hashable {
        case history(PaymentHistory)
    }
    
    private var viewModel = PaymentHistoryViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        title = "결제 내역 조회"
        
        setupLayout()
        setupRefreshControl()
        setupDatasource()
        viewModel.fetchHistory(size: 5)
        bind()
    }
    
    private func bind() {
        viewModel.history
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                DispatchQueue.main.async{
                    self?.collectionView.refreshControl?.endRefreshing()
                }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    switch error{
                    case .encodingFailed:
                        self?.showConfirmationPopup(mainText: "네트워크 오류", subText: "EncodingFailed", centerButtonTitle: "확인")
                    case .networkFailure(let code):
                        self?.showConfirmationPopup(mainText: "네트워크 오류", subText: "\(code)\n 세션이 만료되었습니다 로그인을 다시해주세요.", centerButtonTitle: "확인"){
                            DispatchQueue.main.async {
                                let vc = LoginViewController()
                                vc.modalPresentationStyle = .fullScreen
                                vc.title = "로그인"
                                self?.present(vc, animated: true)
                            }
                            
                        }
                    case .invalidResponse:
                        self?.showConfirmationPopup(mainText: "네트워크 오류", subText: "invalidResponse", centerButtonTitle: "확인")
                    case .unknown:
                        self?.showConfirmationPopup(mainText: "네트워크 오류", subText: "알수없는 에러", centerButtonTitle: "확인")
                    }
                }
            } receiveValue: { [weak self] history in
                DispatchQueue.main.async{
                    self?.collectionView.refreshControl?.endRefreshing()
                }
                
                let items = history.compactMap{ $0 }
                print(items)
                let sectionItem = items.map { Item.history($0) }
                if sectionItem.count > 0 {
                    self?.applySectionItems(sectionItem, to: .main)
                }
            }
            .store(in: &subscriptions)
        
        viewModel.selectedHistory
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [unowned self] item in
                if item.status == "FAILED" {
                    viewModel.repayment(id: item.id)
                }
            }
            .store(in: &subscriptions)
            

    }
    
    private func setupDatasource(){
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item{
            case .history(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentHistoryCell.identifier, for: indexPath) as! PaymentHistoryCell
                cell.configure(item)
                return cell
            }
        })
    }
    
    
    private func setupLayout(){
        [collectionView].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .main:
                return self.LayoutSection()
            }
        }
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
    
    private func LayoutSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [itemLayout])
        groupLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        groupLayout.interItemSpacing = .fixed(10)
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.interGroupSpacing = 10
        
        return section
    }
}

extension PaymentHistoryViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _history = viewModel.history.value[indexPath.item+1] else { return }
        if _history.status != "FAILED" { return }
        switch Section.allCases[indexPath.section]{
        case.main:
            showPopup(
                mainText: "재결제 시도",
                subText: "\(_history.amount)원을 재결제 하시겠습니까?\n결제 하기 전 카드를 먼저 등록해야 합니다.",
                leftButtonTitle: "취소",
                rightButtonTitle: "결제하기") {
                    print("취소")
                } rightButtonHandler: {
                    self.viewModel.didPageSelect(at: indexPath)
                }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height) && isInfiniteScroll {
            isInfiniteScroll = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.viewModel.fetchHistory(size: 5)
                self.isInfiniteScroll = true
            }
        }
    }
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAPIKeys), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshAPIKeys() {
        viewModel.fetchHistory(size: 5)
    }
}
