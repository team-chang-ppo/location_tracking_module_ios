//
//  AnalzyeAPIViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import UIKit
import SwiftUI

class AnalzyeAPIViewController: UIViewController {

    private var hostingController: UIHostingController<ChartView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "요금 명세서"
        self.view.backgroundColor = .systemBackground

        let swiftUIView = ChartView(apiResponse: ApiResponse.generateDummyData())

        let hostingController = UIHostingController(rootView: swiftUIView)
        self.hostingController = hostingController

        self.addChild(hostingController)
        hostingController.view.frame = self.view.bounds
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
