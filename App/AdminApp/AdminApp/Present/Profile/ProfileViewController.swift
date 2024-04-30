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

// 310 60 t 10 l 8 b10 r8
class ProfileViewController: UIViewController, UICollectionViewDelegate {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.register(SmallCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SmallCellHeader.identifier)
        $0.register(SmallCellFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SmallCellFooter.identifier)
        $0.register(ProfileViewCell.self, forCellWithReuseIdentifier: ProfileViewCell.identifier)
        $0.register(CreditCardViewCell.self, forCellWithReuseIdentifier: CreditCardViewCell.identifier)
        $0.register(RegisterCreditCardViewCell.self, forCellWithReuseIdentifier: RegisterCreditCardViewCell.identifier)
        $0.register(OtherViewCell.self, forCellWithReuseIdentifier: OtherViewCell.identifier)
        $0.showsVerticalScrollIndicator = false
        
    }
    enum Section : CaseIterable{
        case Profile
        case CardList
        case CardRegister
        case Other
        var header : String{
            switch self {
            case .Profile: return "계정 정보"
            case .CardList: return "지불 방법"
            case .CardRegister: return "카드 등록"
            case .Other: return "계정 접근"
            }
        }
        var footer : String{
            switch self {
            case .Profile: return "\n\n"
            case .CardList: return "기본 지불 방법은 맨 위에 위치합니다. 지불 방법을 삭제하거나 순서를 변경하려면 카드를 탭 해주세요.\n\n"
            case .CardRegister: return "Location Module을 사용하기 위하여 카카오페이를 통해 지불 방법을 추가할 수 있습니다.\n\n기본 지불 방법으로 결제할 수 없으면 위에서부터 순서에 따라 다른 지불 방법으로 결제를 시도하도록 진행합니다.\n\n"
            case .Other: return "Location Module은 사용자의 소중한 개인 정보를 보호합니다.\n\n"
            }
        }
    }
    
    enum Item: Hashable {
        case userProfile(UserProfile?)
        case cardList(Card?)
        case registerCreditCard(ProfileItem)
        case otherItem(ProfileItem)
    }
    
    private var viewModel = ProfileViewModel(profileItem: ProfileItem.list, otherItem: ProfileItem.otherlist)
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupUI()
        bind()
        viewModel.fetchUserData()
        viewModel.fetchCardList()
    }
    
    private func setupUI() {
        self.navigationItem.title = "내 정보"
        self.tabBarItem.title = "계정 관리"
        self.view.backgroundColor = .defaultBackgroundColor
    }
    
    
    private func bind() {
        
        viewModel.userModel
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            }, receiveValue: { [weak self] UserProfile in
                let sectionItem = Item.userProfile(UserProfile)
                self?.applySectionItems([sectionItem], to: .Profile)
            })
            .store(in: &subscriptions)
        
        viewModel.cards
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            }, receiveValue: { [weak self] response in
                let sectionItem = response.map { Item.cardList($0) }
                self?.applySectionItems(sectionItem, to: .CardList)
            })
            .store(in: &subscriptions)
        
        viewModel.profileItem
            .receive(on: RunLoop.main)
            .sink { [weak self] list in
                let sectionItems = list.map { Item.registerCreditCard($0) }
                self?.applySectionItems(sectionItems, to: .CardRegister)
            }.store(in: &subscriptions)
        
        viewModel.otherItem
            .receive(on: RunLoop.main)
            .sink { [weak self] list in
                let sectionItems = list.map { Item.otherItem($0) }
                self?.applySectionItems(sectionItems, to: .Other)
            }.store(in: &subscriptions)
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
    
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        collectionView.delegate = self
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
                
            case .userProfile(let userProfile):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewCell.identifier, for: indexPath) as! ProfileViewCell
                cell.configure(item: userProfile)
                return cell
            case .cardList(let cardList):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCardViewCell.identifier, for: indexPath) as! CreditCardViewCell
                cell.configure(item: cardList)
                return cell
            case .registerCreditCard(let item):
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCreditCardViewCell.identifier, for: indexPath) as! RegisterCreditCardViewCell
                cell.configure(title: item.title)
                return cell
            case .otherItem(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherViewCell.identifier, for: indexPath) as! OtherViewCell
                cell.configure(title: item.title)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SmallCellHeader.identifier, for: indexPath) as? SmallCellHeader else {
                    return nil
                }
                let section = Section.allCases[indexPath.section]
                header.configure(subtitle: section.header)
                return header
            } else if kind == UICollectionView.elementKindSectionFooter {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SmallCellFooter.identifier, for: indexPath) as? SmallCellFooter else {
                    return nil
                }
                let section = Section.allCases[indexPath.section]
                footer.configure(subtitle: section.footer)
                return footer
            }
            return nil
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .Profile:
                return self.LayoutSection()
            case .CardList:
                return self.LayoutSection()
            case .CardRegister:
                return self.LayoutSection()
            case .Other:
                return self.LayoutSection()
            }
        }
        
    }
    private func LayoutSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [itemLayout])
        groupLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        groupLayout.interItemSpacing = .fixed(10)  // 적절한 간격으로 조정
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 15, trailing: 8) // 섹션과 헤더/푸터 사이 간격 조정
        section.interGroupSpacing = 10
        
        // Header and Footer
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.boundarySupplementaryItems = [header, footer]
        return section
    }
}

extension ProfileViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.allCases[indexPath.section] {
        case.Profile:
            showPopup(
                mainText: "정말로 탈퇴 하시겠어요?",
                subText: "회원 탈퇴 시 저장된 API KEY가 모두 사라져요",
                leftButtonTitle: "취소",
                rightButtonTitle: "확인",
                leftButtonHandler: {
                    print("취소되었습니다")
                },
                rightButtonHandler: {
                    self.viewModel.logout()
                }
            )
        case .CardList:
            showConfirmationPopup(
                mainText: "네트워크 연결 오류",
                subText: "네트워크 오류로 서비스 접속이 불가능해요",
                centerButtonTitle: "확인") {
                    print("확인")
                }
        case .CardRegister:
            break
        case .Other:
            break
        }
    }
}
