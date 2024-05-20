//
//  APIKeyDetailViewModel.swift
//  AdminApp
//
//  Created by 승재 on 5/10/24.
//

import Foundation
import Combine

final class APIKeyDetailViewModel {
    var ApiKey = CurrentValueSubject<APICard, APIKeyError>(APICard(id: 0, value: "value", grade: "GRADE_FREE", paymentFailureBannedAt: "N/A", cardDeletionBannedAt: "N/A",createdAt: "N/A"))
    var ApiKeyItem: CurrentValueSubject<[APIKeyItem], Never>
    var eventPublisher = PassthroughSubject<String, APIKeyError>()
    private let networkService = NetworkService(configuration: .default)
    private var cancellables = Set<AnyCancellable>()
    
    init(ApiKeyItem: [APIKeyItem], apiKey: APICard) {
        self.ApiKeyItem = CurrentValueSubject(ApiKeyItem)
        self.ApiKey = CurrentValueSubject(apiKey)
    }
    
    func deleteAPIKey() {
        let resource = Resource<APIKeyDeleteResponse?>(
            base: Config.serverURL,
            path: "api/apikeys/v1/\(ApiKey.value.id)",
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
            })
            .store(in: &cancellables)
    }
    
}
