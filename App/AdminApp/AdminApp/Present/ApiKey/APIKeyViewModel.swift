//
//  APIKeyViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation
import Combine
import Alamofire

enum APIKeyError: Error {
    case encodingFailed
    case networkFailure(Error)
    case invalidResponse
    case unknown
}
final class APIKeyViewModel {
    var ApiKey = CurrentValueSubject<[APICard], APIKeyError>([APICard(id: 0, value: "value", grade: "GRADE_FREE", paymentFailureBannedAt: "N/A", cardDeletionBannedAt: "N/A",createdAt: "N/A")])
    var ApiKeyItem: CurrentValueSubject<[APIKeyItem], Never>
    
    var eventPublisher = PassthroughSubject<String, APIKeyError>()
    private let networkService = NetworkService(configuration: .default)
    private var cancellables = Set<AnyCancellable>()
    
    init( ApiKeyItem: [APIKeyItem]) {
        self.ApiKeyItem = CurrentValueSubject(ApiKeyItem)
    }
    
    func fetchAPIKeys(firstApiKeyId: Int, size: Int) {
        let resource = Resource<APIKeyListResponse?>(
            base: Config.serverURL,
            path: "api/apikeys/v1/member/me",
            params: ["firstApiKeyId":"\(firstApiKeyId)",
                     "size":"\(size)"
                    ],
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
                    self?.ApiKey.send(completion: .failure(.networkFailure(error)))
                }
            } receiveValue: { [weak self] apikeyListResponse in
                guard let apikey = apikeyListResponse?.result.data.apiKeyList else {
                    self?.ApiKey.send(completion: .failure(.invalidResponse))
                    return
                }
                self?.ApiKey.send(apikey)
            }
            .store(in: &cancellables)
    }
    
    func deleteAPIKey(id: Int) {
        let resource = Resource<APIKeyDeleteResponse?>(
            base: Config.serverURL,
            path: "api/apikeys/v1/\(id)",
            params: [:],
            header: [:],
            httpMethod: .DELETE
        )
        
        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.eventPublisher.send(completion: .failure(.networkFailure(error)))
                }
            }, receiveValue: { [weak self] apikeyDeleteResponse in
                self?.eventPublisher.send("API Key가 성공적으로 삭제되었습니다.")
                if let index = self?.ApiKey.value.firstIndex(where: { $0.id == id }) {
                    var currentKeys = self?.ApiKey.value
                    currentKeys?.remove(at: index)
                    self?.ApiKey.send(currentKeys ?? [])
                }
            })
            .store(in: &cancellables)
    }
    
}
