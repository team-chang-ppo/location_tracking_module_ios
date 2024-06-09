import SwiftUI

struct HomeView: View {
    @State private var apiKey: String = ""
    @State private var navigateToTestView: Bool = false

    var body: some View {
        NavigationStack {
            Spacer().frame(height: 50)
            VStack {
                Text("배달기사 앱")
                    .font(.title)
                TextField("API 키를 입력해주세요", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if !apiKey.isEmpty {
                        navigateToTestView = true
                    }
                }) {
                    Text("확인")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .background(
                    NavigationLink(destination: TestView(apiKey: apiKey), isActive: $navigateToTestView) {
                        EmptyView()
                    }
                    .hidden()
                )
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
