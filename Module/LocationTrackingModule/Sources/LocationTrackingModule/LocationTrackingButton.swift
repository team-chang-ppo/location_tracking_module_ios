//
//  SwiftUIView.swift
//  
//
//  Created by 승재 on 5/22/24.
//

import SwiftUI

public struct LocationTrackingButton: View {
    @ObservedObject var viewModel: LocationTrackingViewModel
    @State private var isTracking: Bool = false

    init(viewModel: LocationTrackingViewModel, isTracking: Bool) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Button(action: {
            if !isTracking {
                viewModel.startTracking()
            } else {
                viewModel.stopTracking()
            }
            isTracking.toggle()
        }) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.white)
                Text(isTracking ? "배달 도착" : "배달 시작")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }
            .frame(width: 280, height: 42)
            .background(isTracking ? Color(.systemRed).opacity(0.9) : Color(.systemBlue).opacity(0.9))
            .clipShape(Capsule())
        }
    }
}
