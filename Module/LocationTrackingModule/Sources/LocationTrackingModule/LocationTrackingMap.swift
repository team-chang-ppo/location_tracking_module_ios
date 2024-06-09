import SwiftUI
import MapKit
import CoreLocation

@available(iOS 17.0, *)
public struct LocationTrackingMap: View {
    
    @StateObject private var viewModel: LocationTrackingViewModel
    @State private var position: MapCameraPosition = .automatic
    @State private var showAlert = false
    
    public init(module: LocationTrackingModule, origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
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
            }
            .overlay(alignment: .bottom) {
                LocationTrackingButton(viewModel: viewModel, isTracking: false)
                    .padding()
            }
            .overlay(alignment: .topTrailing) {
                VStack {
                    Spacer().frame(height: 40)
                    Button(action: {
                        UIPasteboard.general.string = viewModel.token
                        showAlert = true
                    }) {
                        Image(systemName: "doc.on.doc")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .padding()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("성공"), message: Text("토큰이 복사되었습니다 !"), dismissButton: .default(Text("확인")))
            }
        }
    }
}

#Preview {
    LocationTrackingMap(
        module: LocationTrackingModule(
            serverURL: "example.com",
            key: "api_key",
            configuration: .default
        ),
        origin: CLLocationCoordinate2D(latitude: 36.13782325523192, longitude: 128.42060202080336),
        destination: CLLocationCoordinate2D(latitude: 36.14551321622079, longitude: 128.3923148389114)
    )
}
