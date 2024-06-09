import SwiftUI

struct HomeView: View {
    @State private var pairToken: String = ""
    @State private var navigateToTestView: Bool = false

    var body: some View {
        NavigationStack {
            Spacer().frame(height: 50)
            VStack {
                Text("유저 앱")
                    .font(.title)
                TextField("Token을 입력해주세요", text: $pairToken)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                NavigationLink(destination: UserView(pairToken: pairToken), isActive: $navigateToTestView) {
                    Button(action: {
                        if !pairToken.isEmpty {
                            navigateToTestView = true
                        }
                    }) {
                        Text("확인")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
