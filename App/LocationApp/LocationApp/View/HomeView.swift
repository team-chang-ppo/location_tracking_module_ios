//
//  HomeView.swift
//  LocationApp
//
//  Created by 승재 on 5/22/24.
//

import SwiftUI

struct HomeView: View {
    @State private var apiKey: String = ""
    @State private var pairToken: String = ""
    @State private var navigateToTestView: Bool = false
    @State private var navigateToUserView: Bool = false

    var body: some View {
        NavigationStack {
            VStack {

                Divider()
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
                .navigationDestination(isPresented: $navigateToTestView) {
                    TestView(apiKey: apiKey)
                }
                Spacer().frame(height: 50)
                Divider()
                Spacer().frame(height: 50)
                
                Text("사용자 앱")
                    .font(.title)
                TextField("발급받은 Token을 입력해주세요", text: $pairToken)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    if !pairToken.isEmpty {
                        navigateToUserView = true
                    }
                }) {
                    Text("확인")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .navigationDestination(isPresented: $navigateToUserView) {
                    UserView(pairToken: pairToken)
                }
            }
            .navigationBarTitle("데모용 앱", displayMode: .large)
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
