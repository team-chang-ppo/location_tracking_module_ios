//
//  ProfileViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation
import Combine
import Alamofire

enum ProfileError: Error {
    case encodingFailed
    case networkFailure(Error)
    case invalidResponse
    case unknown
}

final class ProfileViewModel {
    var userModel = CurrentValueSubject<UserProfile?,ProfileError>(UserProfile(id: 0, name: "nil", username: "계정 정보가 없습니다.", profileImage: "", roles: [""], paymentFailureBannedAt: nil, createdAt: ""))
    var cards = CurrentValueSubject<[Card?], ProfileError>([Card(id: 0, type: "", issuerCorporation: "카드 정보가 없습니다.", bin: "", paymentGateway: "", createdAt: "")])
    var profileItem : CurrentValueSubject<[ProfileItem],Never>
    var otherItem : CurrentValueSubject<[ProfileItem],Never>
    private let networkService = NetworkService(configuration: .default)
    private var subscriptions = Set<AnyCancellable>()
    
    init(profileItem: [ProfileItem], otherItem: [ProfileItem]) {
        self.profileItem = CurrentValueSubject(profileItem)
        self.otherItem = CurrentValueSubject(otherItem)
    }
    
    func fetchUserData() {
        
        let resource = Resource<UserResponse?>(
            base: Config.serverURL,
            path: "api/members/v1/me",
            params: [:],
            header: [:],
            httpMethod: .GET
        )
        
        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.userModel.send(completion: .failure(.networkFailure(error)))
                }
            } receiveValue: { [weak self] userResponse in
                guard let user = userResponse?.result.data else {
                    self?.userModel.send(completion: .failure(.invalidResponse))
                    return
                }
                self?.userModel.send(user)
            }
            .store(in: &subscriptions)
    }
    
    func fetchCardList() {
        let resource = Resource<CardListResponse?>(
            base: Config.serverURL,
            path: "api/cards/v1/member/me",
            params: [:],
            header: [:],
            httpMethod: .GET
        )
        
        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.cards.send(completion: .failure(.networkFailure(error)))
                }
            } receiveValue: { [weak self] response in
                guard let cardList = response?.result.data.cardList else {
                    self?.cards.send(completion: .failure(.invalidResponse))
                    return
                }
                self?.cards.send(cardList)
            }
            .store(in: &subscriptions)
    }
    
    func deleteCard(with cardID: Int) {
        let resource = Resource<CardListResponse?>(
            base: Config.serverURL,
            path: "api/cards/v1/member/me",
            params: [:],
            header: [:],
            httpMethod: .DELETE
        )
        
//        let urlString = "\(Config.serverURL)/api/cards/v1/\(cardID)"
//        AF.request(urlString, method: .delete)
//            .response { response in
//                switch response.result {
//                case .success:
//                    print("Successfully deleted card with ID: \(cardID)")
//                    DispatchQueue.main.async {
//                        self.fetchCardList()
//                    }
//                case .failure(let error):
//                    print("Failed to delete card with ID: \(cardID), error: \(error)")
//                }
//            }
    }
    
    func logout(){
        KeychainManager.delete(key: "SessionID")
    }
}
