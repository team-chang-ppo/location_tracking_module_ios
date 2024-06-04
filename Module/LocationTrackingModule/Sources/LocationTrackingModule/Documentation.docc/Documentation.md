# ``LocationTrackingModule``

Chang-ppo 에서 제공하는 API를 활용하여 사용자의 위치정보를 가져오는 스위프트 패키지.

## Overview

LocationTrackingModule은 [Chang-ppo](https://github.com/team-chang-ppo) 에서 제공하는 API 를 통해 사용자의 위치정보를 쉽게 가져올 수 있게합니다.

### 제공하는 기능
현재 제공하고 있는 기능은 다음과 같습니다.
- 트래킹 토큰 발행
- 트래킹 시작
- 위치정보 가져오기
- 트래킹 종료

### 지원 버전
- swift 5.9+
- iOS 17+


## 시작하기
> IMPORTANT: 사용 하기 전 Tracking Module Admin 에서 API 키를 발급받아야 합니다.

> IMPORTANT: 사용 하기 전 위치 권한 설정이 필요합니다. info.plist 에서 Privacy - Location When in Use Usage Description을 작성해주세요.


```swift
import SwiftUI
import MapKit
import LocationTrackingModule


extension LocationTrackingModule{
    static let shared = LocationTrackingModule(
        serverURL: "{서버_주소}",
        key: "{발급받은_API_KEY}",
        configuration: .default
    )
}

struct TestView: View {

    var body: some View {
        VStack{
            /* Tracking 할 대상에 사용하는 Map View */
            LocationTrackingMap(
                module: LocationTrackingModule.shared,
                origin: CLLocationCoordinate2D(latitude: 36.13782325523192, longitude: 128.42060202080336),
                destination: CLLocationCoordinate2D(latitude: 36.14551321622079, longitude: 128.3923148389114))
        }

    }
    
}

struct UserView: View {
    var body: some View {
        UserTrackingMap(
            pairToken: "{발급받은_TOKEN}",
            module: LocationTrackingModule.shared,
            origin: CLLocationCoordinate2D(latitude: 36.13782325523192, longitude: 128.42060202080336),
            destination: CLLocationCoordinate2D(latitude: 36.14551321622079, longitude: 128.3923148389114))
    }
}
```


## 주요기능

### 트래킹 토큰 발행


```swift
토큰을 발행합니다 
let token = apiRequest.getToken()
```
> NOTE : 토큰은 위치정보를 가져오기 위해 사용됩니다.

### 트래킹 시작

사용자의 위치를 서버로 전송합니다. LocationTrackingMap을 사용할 경우 자동으로 서버로 위치를 전송합니다.
```swift
LocationTrackingModule.shared.start { result in
    switch result {
        case .success(let flag) { ... }
        case .failure(let error) { ... }
    }
}
```
> NOTE : 좌표는 위도 경도를 사용합니다.

### 위치정보 가져오기

토큰을 발행합니다.
```swift
LocationTrackingModule.shared.get{ result in
    switch result {
        case .success(let location) { ... }
        case .failure(let error) { ... }
    }
}
```

### 트래킹 종료

트래킹을 종료하는 함수입니다.
```swift
LocationTrackingModule.shared.stop{ result in
    switch result {
        case .success(let flag) { ... }
        case .failure(let error) { ... }
    }
}
```
