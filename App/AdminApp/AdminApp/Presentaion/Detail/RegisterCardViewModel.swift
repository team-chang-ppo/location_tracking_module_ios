//
//  RegisterCardViewModel.swift
//  AdminApp
//
//  Created by 승재 on 3/29/24.
//

import Foundation
import Combine

final class RegisterCardViewModel {
    private let networkService = NetworkService(configuration: .default)
    private var subscriptions = Set<AnyCancellable>()
    
    let paymentURL = PassthroughSubject<String?, Never>()
    
    func fetchPaymentURL() {
        let paymentRequest = PaymentRequest.temp
        guard let jsonData = try? JSONEncoder().encode(paymentRequest) else {
            paymentURL.send(nil)
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
            .sink(receiveCompletion: { [weak self] success in
                switch success {
                case .finished:
                    break
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                    self?.paymentURL.send(nil)
                }
            }, receiveValue: { [weak self] paymentResponse in
                self?.paymentURL.send(paymentResponse.next_redirect_mobile_url)
            })
            .store(in: &subscriptions)
    }
}
