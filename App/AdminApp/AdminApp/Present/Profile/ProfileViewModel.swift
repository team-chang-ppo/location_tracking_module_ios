//
//  ProfileViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation
import Combine

enum ProfileError: Error {
    case encodingFailed
    case networkFailure(Error)
    case invalidResponse
    case unknown
}

final class ProfileViewModel {
    var userModel = CurrentValueSubject<UserProfile?,ProfileError>(UserProfile(id: 0, name: "nil", username: "계정 정보가 없습니다.", profileImage: "", roles: ["ROLE_FREE"], paymentFailureBannedAt: nil, createdAt: ""))
    var cards = CurrentValueSubject<[Card?], ProfileError>([Card(id: -1, type: "", issuerCorporation: "카드 정보가 없습니다.", bin: "카드를 등록해주세요", paymentGateway: "", createdAt: "")])
    var eventPublisher = PassthroughSubject<String, ProfileError>()
    
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
                if self?.userModel.value?.roles.first != "ROLE_FREE"{
                    self?.fetchCardList()
                }else{
                    self?.cards.value = [Card(id: -1, type: "", issuerCorporation: "카드 정보가 없습니다.", bin: "카드를 등록해주세요", paymentGateway: "", createdAt: "")]
                }
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
        let resource = Resource<DeleteCardResponse?>(
            base: Config.serverURL,
            path: "api/cards/v1/\(cardID)",
            params: [:],
            header: [:],
            httpMethod: .DELETE
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
                guard let success = response?.success else {
                    self?.cards.send(completion: .failure(.invalidResponse))
                    return
                }
                if success == false {
                    self?.cards.send(completion: .failure(.unknown))
                    return
                }
                self?.fetchUserData()
                self?.eventPublisher.send("카드가 성공적으로 삭제되었어요 !")
                
            }
            .store(in: &subscriptions)
    }


    
    func deleteUser(){
        let resource = Resource<DeleteUserResponse?>(
            base: Config.serverURL,
            path: "api/members/v1/request/me",
            params: [:],
            header: [:],
            httpMethod: .PUT
        )
        
        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    self?.eventPublisher.send(completion: .failure(.networkFailure(error)))
                }
            } receiveValue: { [weak self] response in
                guard let data = response?.success else {
                    self?.eventPublisher.send(completion: .failure(.invalidResponse))
                    return
                }
                if data == false {
                    self?.eventPublisher.send(completion: .failure(.unknown))
                    return
                }
                KeychainManager.delete(key: "SessionID")
                self?.eventPublisher.send("회원 탈퇴 신청이 되었어요 !")
            }
            .store(in: &subscriptions)
    }
    
    
    func logout(){
        let resource = Resource<LogoutResponse?>(
            base: Config.serverURL,
            path: "logout/oauth2",
            params: [:],
            header: [:],
            httpMethod: .GET
        )
        
        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    self?.eventPublisher.send(completion: .failure(.networkFailure(error)))
                }
            } receiveValue: { [weak self] response in
                guard let data = response?.success else {
                    self?.eventPublisher.send(completion: .failure(.invalidResponse))
                    return
                }
                if data == false {
                    self?.eventPublisher.send(completion: .failure(.unknown))
                    return
                }
                
                KeychainManager.delete(key: "SessionID")
                self?.eventPublisher.send("로그아웃 되었습니다.")
            }
            .store(in: &subscriptions)
    }
}
