import Foundation
import MapKit
import Combine

final class LocationTrackingViewModel: ObservableObject {
    private var locationTrackingModule: LocationTrackingModule
    
    private var timer: AnyCancellable?
    
    @Published var route: MKRoute?
    @Published var estimatedTime: Int?
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var trackingError: Error?
    @Published var token: String?
    
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    init(module: LocationTrackingModule,
         origin: CLLocationCoordinate2D,
         destination: CLLocationCoordinate2D) {
        self.locationTrackingModule = module
        self.origin = origin
        self.destination = destination
        self.getDirections()
        
    }
    
    func getDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        
        Task {
            do {
                let response = try await directions.calculate()
                if let firstRoute = response.routes.first {
                    DispatchQueue.main.async {
                        self.route = firstRoute
                        self.estimatedTime = (Int(firstRoute.expectedTravelTime) / 60) + 1
                        print("Estimated travel time: \(String(describing: self.estimatedTime!)) minutes")
                    }
                }
            } catch {
                print("Error calculating directions: \(error)")
            }
        }
    }
    
    func startTracking() {
        locationTrackingModule.start(
            startLatitude: origin.latitude,
            startLongitude: origin.longitude,
            endLatitude: destination.latitude,
            endLongitude: destination.longitude,
            estimatedArrivalTime: estimatedTime ?? 0) { result in
            switch result {
            case .success:
                self.token = self.locationTrackingModule.getToken()
                print("Tracking started successfully")
            case .failure(let error):
                print("Failed to start tracking: \(error)")
            }
        }
    }
    
    func stopTracking() {
        locationTrackingModule.end { result in
            switch result {
            case .success:
                print("Tracking stopped successfully")
            case .failure(let error):
                print("Failed to stop tracking: \(error)")
            }
        }
    }
    
    func getTracking(pairToken: String) {
        locationTrackingModule.getLocation(pairToken: pairToken) { [weak self] result in
            switch result {
            case .success(let location):
                DispatchQueue.main.async {
                    self?.currentLocation = location.coordinate
                }
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    DispatchQueue.main.async {
                        self?.trackingError = networkError
                    }
                }
                print("Failed to stop tracking: \(error)")
                self?.stopTimer()
            }
        }
    }
    
    func startTrackingTimer(pairToken: String) {
        timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.getTracking(pairToken: pairToken)
        }
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func errorMessage(for error: NetworkError) -> String {
            switch error {
            case .invalidRequest:
                return "JWT 토큰이 존재하지 않습니다."
            case .invalidResponse:
                return "서버로부터 응답을 받아올 수 없습니다."
            case .responseError(let statusCode):
                switch statusCode {
                case 404:
                    return "좌표가 존재하지 않거나, 좌표 데이터가 올바른 형식이 아닙니다."
                case 410:
                    return "트래킹이 종료되었습니다."
                default:
                    return "네트워크 에러가 발생하였습니다."
                }
            case .jsonDecodingError(let error):
                return "Failed to decode response: \(error.localizedDescription)"
            case .serverError(let message):
                return "Server error: \(message)"
            }
        }
}
