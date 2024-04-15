//
//  RegisterCardViewModel.swift
//  AdminApp
//
//  Created by 승재 on 3/29/24.
//

import Foundation
import Combine

enum PaymentError: Error {
    case encodingFailed
    case networkFailure(Error)
    case invalidResponse
    case unknown
}

final class RegisterCardViewModel {
    private let networkService = NetworkService(configuration: .default)
    private var subscriptions = Set<AnyCancellable>()
    
    let paymentURL = PassthroughSubject<String?, PaymentError>()
    
    func fetchPaymentURL() {
        let paymentRequest = PaymentRequest.temp
        guard let jsonData = try? JSONEncoder().encode(paymentRequest) else {
            paymentURL.send(completion: .failure(.encodingFailed))
            return
        }
        
        let resource = Resource<PaymentResponse>(
            base: Config.serverURL,
            path: "payment/start-subscription/",
            params: [:],
            header: ["Content-Type": "application/json"],
            httpMethod: .POST,
            body: jsonData
        )
        
        networkService.load(resource)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.paymentURL.send(completion: .failure(.networkFailure(error)))
                }
            }, receiveValue: { [weak self] paymentResponse in
                guard let url = paymentResponse.next_redirect_mobile_url, !url.isEmpty else {
                    self?.paymentURL.send(completion: .failure(.invalidResponse))
                    return
                }
                self?.paymentURL.send(url)
            })
            .store(in: &subscriptions)
    }

}
