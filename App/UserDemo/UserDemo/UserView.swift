import SwiftUI
import LocationTrackingModule
import MapKit

struct UserView: View {
    let pairToken: String

    var body: some View {
        UserTrackingMap(
            pairToken: pairToken,
            module: LocationTrackingModule(serverURL: APIConstants.BaseURL, configuration: .default),
            origin: CLLocationCoordinate2D(latitude: 36.13847720785065, longitude: 128.396414838321),
            destination: CLLocationCoordinate2D(latitude: 36.139053085374016, longitude: 128.396680562473)
        )
    }
}

#Preview {
    UserView(pairToken: "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjaGFuZy1wcG8tdHJhY2tpbmctbW9kdWxlIiwiU0NPUEUiOlsiV1JJVEVfVFJBQ0tJTkdfQ09PUkRJTkFURSIsIlJFQURfVFJBQ0tJTkdfQ09PUkRJTkFURSJdLCJHUkFERV9UWVBFIjoiR1JBREVfQ0xBU1NJQyIsIkFQSUtFWV9JRCI6NywiTUVNQkVSX0lEIjo0LCJUUkFDS0lOR19JRCI6IjAwOTcyMmExLThmN2UtNDk0Mi05NzE4LTAwOTI5Nzk3Y2EyZCIsImlhdCI6MTcxNzU1OTMzOSwiZXhwIjoxNzE3NTYwMjM5fQ.Abk2cixQFUOcvwtVK2o7ICB20rIKZCFPgx6x8qmCuSA")
}
