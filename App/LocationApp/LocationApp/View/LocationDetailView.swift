//
//  testView.swift
//  LocationApp
//
//  Created by 승재 on 3/14/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel: LocationDetailViewModel
    @StateObject var locationManager = LocationManager()
    @State var isTracking: Bool = false
    
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    @State private var position: MapCameraPosition = .automatic
    
    init(origin: CLLocationCoordinate2D,
         destination: CLLocationCoordinate2D) {
        self.origin = origin
        self.destination = destination
        _viewModel = StateObject(wrappedValue: LocationDetailViewModel(origin: origin, destination: destination))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Map(position: $position){
                    
                    UserAnnotation()
                    Annotation(
                        "도착",
                        coordinate: destination,
                        anchor: .bottom
                    ) {
                        ZStack{
                            Image(systemName: "house.circle.fill")
                                .resizable()
                                .frame(width: 26, height: 26)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .red)
                                .padding(5)
                            // 여기에 예상 도착 시간을 표시하는 Text 뷰 추가
                            VStack {
                                if let eta = viewModel.estimatedTime{
                                    Text("예상시간 \(eta)분") // ViewModel에서 예상 시간 가져오기
                                        .lineLimit(nil) // 텍스트 줄 수 제한 없음
                                        .multilineTextAlignment(.center) // 여러 줄 텍스트의 경우 가운데 정렬
                                        .frame(minWidth: 80,maxWidth: .infinity)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(.red)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    Spacer().frame(height: 60) // Text를 아이콘 위로 올리기
                                }
                                
                            }
                        }
                    }
                    Annotation(
                        "출발",
                        coordinate: origin,
                        anchor: .bottom
                    ){
                        ZStack{
                            Image(systemName: "car.circle.fill")
                                .resizable()
                                .frame(width: 26, height: 26)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .blue)
                        }
                    }
                    if let route = viewModel.route {
                        MapPolyline(route)
                            .stroke(.blue, lineWidth: 5)
                    }
                }
                .onAppear(){
                    viewModel.getDirections()
                    locationManager.requestLocationAccess()
                }
                .edgesIgnoringSafeArea(.top)
                
                Spacer()
                    .frame(height: 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 16){
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 21, height: 21)
                        Text("010-1234-5689")
                            .font(.system(size: 18, weight: .bold, design: .default))
                        Image(systemName: "phone.circle.fill")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .symbolRenderingMode(.hierarchical)
                        
                    }
                    Spacer()
                        .frame(height: 5)
                    HStack(spacing: 16){
                        Image(systemName: "location")
                            .resizable()
                            .frame(width: 21, height: 21)
                        Text("고객 주소")
                            .font(.system(size: 18, weight: .bold, design: .default))
                    }
                    HStack{
                        Spacer()
                            .frame(width: 35)
                        Text("경상북도 구미시 대학로 3-33 (거의동) 버킹검 205 (거의동) 버킹검 205호")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundStyle(Color(hex: "#57585A"))
                    }
                }
                .padding()
                
                Spacer()
                    .frame(height: 30)
                
                Button(action: {
                    // 버튼이 눌렸을 때의 액션
                    if isTracking {
                        sendDisconnectRequest()
                    } else {
                        sendConnectRequest()
                    }
                    isTracking.toggle()
                    
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                        Text(isTracking ? "배달 도착" : "배달 시작" )
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                    }
                    .frame(width: 260, height: 42)
                    .background(isTracking ? Color(hex: "#FF0000") : Color(hex: "#596AFF") )
                    .clipShape(Capsule())
                }
                
                
                
                
                
            }
            .onReceive(locationManager.$currentLocation) { currentLocation in
                guard let currentLocation = currentLocation else { return }
                if !isTracking{
                    viewModel.updateRequestLocation(userLocation: currentLocation)
                }
            }
            .navigationBarTitle("상세 확인", displayMode: .inline)
        }
    }
    
    func sendConnectRequest() {
        viewModel.DeliveryStart()
    }
    
    func sendDisconnectRequest() {
        viewModel.DeliveryEnd()
    }
    
    
}


#Preview {
    ContentView(origin: CLLocationCoordinate2D(
        latitude: ConnectRequest.sampleRoute.startPoint.x,
        longitude: ConnectRequest.sampleRoute.startPoint.y),
                destination: CLLocationCoordinate2D(
                    latitude: ConnectRequest.sampleRoute.endPoint.x,
                    longitude: ConnectRequest.sampleRoute.endPoint.y))
}
