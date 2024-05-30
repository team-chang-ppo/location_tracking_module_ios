//
//  ProfileHistoryViewModel.swift
//  AdminApp
//
//  Created by 승재 on 5/15/24.
//

import Foundation
import Combine
//
//enum PaymentHistoryError: Error {
//    case encodingFailed
//    case networkFailure(Error)
//    case invalidResponse
//    case unknown
//}

final class PaymentHistoryViewModel {
    private var lastApiKeyId: Int = CLong.max
    private var hasNext = true
    private var isLoading = false
    
    var history = CurrentValueSubject<[PaymentHistory?],CommonError>([nil])
    let selectedHistory: CurrentValueSubject<PaymentHistory?, Never>
    
    private let networkService = NetworkService(configuration: .default)
    private var cancellables = Set<AnyCancellable>()
    
    init(selectedHistory : PaymentHistory? = nil) {
        self.selectedHistory = CurrentValueSubject(selectedHistory)
    }
    
    func refreshing() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        lastApiKeyId = CLong.max
        hasNext = true
        isLoading = false
        history.send([nil])
        fetchHistory(size: 5)
    }
    
    func fetchHistory(size: Int) {
        guard !isLoading, hasNext else {
            print("Currently loading or no more data available.")
            return
        }
        isLoading = true

        let resource = Resource<PaymentHistoryResponse?>(
            base: Config.serverURL,
            path: "api/payments/v1/member/me",
            params: ["lastApiKeyId": "\(lastApiKeyId)", "size": "\(size)"],
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
                        self?.history.send(completion: .failure(.networkFailure(error)))
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] response in
                    guard let self = self, let data = response?.result else {
                        self?.history.send(completion: .failure(.invalidResponse))
                        return
                    }
                    self.history.send(self.history.value + (data.paymentList ))
                    self.lastApiKeyId = (data.paymentList.last?.id ?? CLong.max)-1
                    self.hasNext = data.hasNext
                }
            )
            .store(in: &cancellables)
        
        
    }
    
    func didPageSelect(at indexPath: IndexPath) {
        if indexPath.item+1 < history.value.count {
            let item = history.value[indexPath.item+1]
            selectedHistory.send(item)
        }
    }
    
    func repayment(id: Int) {
        let resource = Resource<RepaymentResponse?>(
            base: Config.serverURL,
            path: "api/payments/v1/repayment/\(id)",
            params: [:],
            header: [:],
            httpMethod: .POST
        )
        
        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.history.send(completion: .failure(.networkFailure(error)))
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self, let repaymentData = response?.result  else {
                        self?.history.send(completion: .failure(.invalidResponse))
                        return
                    }
                    if response?.success == "true" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            self.refreshing()
                        }
                    }
//                    else {
//                        self.history.send(completion: .failure(.invalidResponse))
//                    }
                    
                }
            )
            .store(in: &cancellables)
    }
    
    
    
}
