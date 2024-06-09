import Foundation
import Combine

final class ChargeViewModel: ObservableObject {
    @Published var apiResponse: ApiChargeResponse?
    @Published var apiCharges: [ApiCharge] = []
    @Published var apiHourlyUsage: [ApiHourlyUsage] = []
    @Published var isLoading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService(configuration: .default)

    func fetchCharges(apiKeyId: Int? = nil) {
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startDate1 = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: calendar.component(.month, from: currentDate) - 2, day: 1))!
        let endDate1 = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: calendar.component(.month, from: currentDate) - 1, day: 0))!
        
        let startDate2 = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: calendar.component(.month, from: currentDate) - 1, day: 1))!
        let endDate2 = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: calendar.component(.month, from: currentDate), day: 0))!
        
        let startDate3 = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: calendar.component(.month, from: currentDate), day: 1))!
        let endDate3 = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: calendar.component(.month, from: currentDate) + 1, day: 0))!
        
        print("\(startDate1)-\(endDate1)")
        print("\(startDate2)-\(endDate2)")
        print("\(startDate3)-\(endDate3)")
        let dateIntervals = [
            (start: startDate1, end: endDate1),
            (start: startDate2, end: endDate2),
            (start: startDate3, end: endDate3)
        ]
        
        let publishers = dateIntervals.map { interval in
            self.fetchChargesForInterval(startDate: interval.start, endDate: interval.end, apiKeyId: apiKeyId)
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching charges: \(error)")
                    }
                },
                receiveValue: { [weak self] responses in
                    guard let self = self else { return }
                    var combinedCharges: [ApiCharge] = []
                    var combinedHourlyUsage: [ApiHourlyUsage] = []
                    
                    responses.forEach { response in
                        combinedCharges.append(contentsOf: self.processApiCharges(response: response))
                        combinedHourlyUsage.append(contentsOf: self.processApiHourlyUsage(response: response))
                    }
                    
                    self.apiCharges = combinedCharges
                    self.apiHourlyUsage = combinedHourlyUsage
                    self.apiResponse = responses.first
                    print("3달치 요금 리스트 -> \(self.apiCharges)")
                    print("오늘 요청 리스트 -> \(self.apiHourlyUsage)")
                    
                    self.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
    
    private func fetchChargesForInterval(startDate: Date, endDate: Date, apiKeyId: Int?) -> AnyPublisher<ApiChargeResponse, Error> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDateString = Utils.localeToUtc(localeDate: dateFormatter.string(from: startDate), dateFormat: "yyyy-MM-dd")
        let endDateString = Utils.localeToUtc(localeDate: dateFormatter.string(from: endDate), dateFormat: "yyyy-MM-dd")
        
        var params = ["startDate": startDateString, "endDate": endDateString]
        if let apiKeyId = apiKeyId {
            params["apiKeyId"] = "\(apiKeyId)"
        }
        
        let memberID = AuthManager.shared.getMemberID() ?? "0"
                
        let resource = Resource<ApiChargeResponse?>(
            base: Config.serverURL,
            path: "api/aggregation/v1/member/\(memberID)/charge",
            params: params,
            header: [:],
            httpMethod: .GET
        )
        
        return networkService.load(resource)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    private func processApiCharges(response: ApiChargeResponse) -> [ApiCharge] {
        var allCharges: [ApiCharge] = []
        response.result.apiKeys.forEach { apiKey in
            guard let apiKey = apiKey else { return }
            let charges = apiKey.dayCharges.flatMap { dayCharge in
                dayCharge.hours.compactMap { hourResult in
                    let dateTimeString = "\(dayCharge.date)T\(String(format: "%02d", hourResult.hour)):00:00Z"
                    let localDateString = Utils.utcToLocale(utcDate: dateTimeString, dateFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    if let localDate = dateFormatter.date(from: localDateString) {
                        return ApiCharge(date: localDate, amount: hourResult.cost, apiKey: apiKey.apiKey)
                    } else {
                        return nil
                    }
                }
            }
            allCharges.append(contentsOf: charges)
        }
        return allCharges
    }
    
    private func processApiHourlyUsage(response: ApiChargeResponse) -> [ApiHourlyUsage] {
        var hourlyUsage: [ApiHourlyUsage] = []
        response.result.apiKeys.forEach { apiKey in
            guard let apiKey = apiKey else { return }
            let usage = apiKey.dayCharges.flatMap { dayCharge in
                dayCharge.hours.compactMap { hourResult in
                    let dateTimeString = "\(dayCharge.date)T\(String(format: "%02d", hourResult.hour)):00:00Z"
                    let dateFormatter = DateFormatter()
//                    print(">>\(dateTimeString)")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    if let localDate = dateFormatter.date(from: dateTimeString), Calendar.current.isDateInToday(localDate) {
                        return ApiHourlyUsage(hour: Calendar.current.component(.hour, from: localDate), count: hourResult.count, apiKey: apiKey.apiKey)
                    } else {
                        return nil
                    }
                }
            }
            hourlyUsage.append(contentsOf: usage)
        }
        return hourlyUsage
    }
}
