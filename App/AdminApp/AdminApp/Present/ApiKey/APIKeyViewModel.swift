//
//  APIKeyViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation
import Combine

enum APIKeyError: Error {
    case encodingFailed
    case networkFailure(Error)
    case invalidResponse
    case unknown
}
final class APIKeyViewModel {
    private var lastApiKeyId: Int = 1
    private var hasNext = true
    private var isLoading = false
    var apiKey = CurrentValueSubject<[APICard?], APIKeyError>([nil])
    let selectedApiKey: CurrentValueSubject<APICard?, Never>
    private let networkService = NetworkService(configuration: .default)
    private var cancellables = Set<AnyCancellable>()

    init(selectedApiKey: APICard? = nil) {
        self.selectedApiKey = CurrentValueSubject(selectedApiKey)
    }

    func refreshing() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        lastApiKeyId = 1
        hasNext = true
        isLoading = false
        apiKey.send([nil])
        fetchAPIKeys(size: 5)
    }
    
    func fetchAPIKeys(size: Int) {
        guard !isLoading, hasNext else {
            print("Currently loading or no more data available.")
            return
        }
        isLoading = true

        let resource = Resource<APIKeyListResponse?>(
            base: Config.serverURL,
            path: "api/apikeys/v1/member/me",
            params: ["firstApiKeyId": "\(lastApiKeyId)", "size": "\(size)"],
            header: [:],
            httpMethod: .GET
        )

        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.apiKey.send(completion: .failure(.networkFailure(error)))
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] response in
                    guard let self = self, let data = response?.result.data else {
                        self?.apiKey.send(completion: .failure(.invalidResponse))
                        return
                    }
                    self.apiKey.send(self.apiKey.value + (data.apiKeyList ))
                    self.lastApiKeyId = (data.apiKeyList.last?.id ?? 0)+1
                    self.hasNext = data.hasNext
                }
            )
            .store(in: &cancellables)
    }

    func didPageSelect(at indexPath: IndexPath) {
        if indexPath.item+1 < apiKey.value.count {
            let item = apiKey.value[indexPath.item+1]
            selectedApiKey.send(item)
        }
    }
}
