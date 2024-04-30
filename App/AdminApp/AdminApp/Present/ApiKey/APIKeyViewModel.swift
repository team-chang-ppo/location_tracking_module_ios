//
//  APIKeyViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation
import Combine
import Alamofire

import OHHTTPStubs
import OHHTTPStubsSwift

final class APIKeyViewModel {
    @Published var APIItem: CurrentValueSubject<[APICard]?, Never>
    @Published var selectedAPIItem: CurrentValueSubject<APICard?, Never>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(APIItem: [APICard]? = nil, selectedAPIItem: APICard? = nil) {
        self.APIItem = CurrentValueSubject(APIItem)
        self.selectedAPIItem = CurrentValueSubject(selectedAPIItem)
    }
    
    
    func didAPISelect(at indexPath: IndexPath) {
        let item = APIItem.value?[indexPath.item]
        selectedAPIItem.send(item)
    }
    
    func fetchAPIKeys(firstApiKeyId: Int, size: Int) {
        let urlString = "\(Config.serverURL)/api/apikeys/v1/member/me"
//        let parameters: [String: Any] = [
//            "firstApiKeyId": firstApiKeyId,
//            "size": size
//        ]
        
//        AF.request(urlString, parameters: parameters)
        AF.request(urlString)
            .validate()
            .publishDecodable(type: APIKeyListResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching API keys: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                print(response)
                guard let apiKeyList = response.value?.result.data.apiKeyList else { return }
                self?.APIItem.send(apiKeyList)
            })
            .store(in: &cancellables)
    }

}
