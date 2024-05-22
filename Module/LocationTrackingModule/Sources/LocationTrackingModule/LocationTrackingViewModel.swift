import Foundation
import MapKit
import Combine

final class LocationTrackingViewModel: ObservableObject {
    private var locationTrackingModule: LocationTrackingModule
    
    private var timer: AnyCancellable?
    
    @Published var route: MKRoute?
    @Published var estimatedTime: Int?
    @Published var currentLocation: CLLocationCoordinate2D?
    
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
                        self.estimatedTime = Int(firstRoute.expectedTravelTime) / 60
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
                print("Failed to get location: \(error)")
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
}
