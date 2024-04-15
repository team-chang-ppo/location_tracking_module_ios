//
//  ProfileViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation
import Combine
import Alamofire

final class ProfileViewModel {
    @Published var userModel: UserModel = UserModel(id: 0, name: "", username: "", profileImage: "", roles: [], paymentFailureBannedAt: nil, createdAt: "")
    @Published var cards: [Card] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUserData() {
        let urlString = "\(Config.serverURL)/api/members/v1/me"
        
        AF.request(urlString)
            .validate()
            .publishDecodable(type: UserResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in

                guard let user = response.value?.result.data else { return }
                self?.userModel = user
            })
            .store(in: &cancellables)
    }
    
    func fetchCardList() {
        let urlString = "\(Config.serverURL)/api/cards/v1/member/me"
        print("fetching Card")
        AF.request(urlString)
            .validate()
            .publishDecodable(type: CardListResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching card list: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                guard let cardList = response.value?.result.data.cardList else { return }
                self?.cards = cardList
                print(self?.cards)
            })
            .store(in: &cancellables)
    }
    
    func deleteCard(with cardID: Int) {
        let urlString = "\(Config.serverURL)/api/cards/v1/\(cardID)"
        AF.request(urlString, method: .delete)
            .response { response in
                switch response.result {
                case .success:
                    print("Successfully deleted card with ID: \(cardID)")
                    DispatchQueue.main.async {
                        self.fetchCardList()
                    }
                case .failure(let error):
                    print("Failed to delete card with ID: \(cardID), error: \(error)")
                }
            }
    }
    
    func logout(){
        KeychainManager.delete(key: "SessionID")
    }
}
