import SwiftUI
import MapKit
import CoreLocation

@available(iOS 17.0, *)
public struct UserTrackingMap: View {
    @StateObject private var viewModel: LocationTrackingViewModel
    @State private var position: MapCameraPosition = .automatic
    private var pairToken: String
    
    public init(pairToken: String, module: LocationTrackingModule, origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        self.pairToken = pairToken
        _viewModel = StateObject(wrappedValue: LocationTrackingViewModel(module: module, origin: origin, destination: destination))
    }
    
    public var body: some View {
        VStack {
            Map(position: $position) {
                UserAnnotation()
                Annotation("도착", coordinate: viewModel.destination, anchor: .bottom) {
                    ZStack {
                        VStack {
                            if let eta = viewModel.estimatedTime {
                                Text("예상시간 \(eta)분")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.center)
                                    .frame(minWidth: 80, maxWidth: .infinity)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    ZStack {
                        Image(systemName: "house.circle.fill")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .red)
                            .padding(5)
                    }
                }
                Annotation("출발", coordinate: viewModel.origin, anchor: .bottom) {
                    ZStack {
                        Image(systemName: "car.circle.fill")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue)
                    }
                }
                if let route = viewModel.route {
                    MapPolyline(route)
                        .stroke(Color.blue, lineWidth: 5)
                }
                if let currentLocation = viewModel.currentLocation {
                    Annotation("현재 위치", coordinate: currentLocation, anchor: .center) {
                        ZStack {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .frame(width: 26, height: 26)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .green)
                        }
                    }
                }
            }
        }
        
        .onAppear {
            viewModel.startTrackingTimer(pairToken: pairToken)
        }
        .onDisappear{
            viewModel.stopTracking()
        }
    }
}


#Preview {
    UserTrackingMap(
        pairToken: "pairToken", module: LocationTrackingModule(
            serverURL: "example.com",
            key: "api_key",
            configuration: .default
        ),
        origin: CLLocationCoordinate2D(latitude: 36.13782325523192, longitude: 128.42060202080336),
        destination: CLLocationCoordinate2D(latitude: 36.14551321622079, longitude: 128.3923148389114)
    )
}
