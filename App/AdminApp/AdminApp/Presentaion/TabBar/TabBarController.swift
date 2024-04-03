//
//  TabBarViewController.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue(ETATabBar(), forKey: "tabBar")
        // 홈 뷰 컨트롤러 생성 및 탭 바 아이템 설정
        let homeVC = HomeViewController()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        // API 키 뷰 컨트롤러 생성 및 탭 바 아이템 설정
        let apiKeyVC = ApiKeyViewController()
        let apiKeyNavController = UINavigationController(rootViewController: apiKeyVC)
        apiKeyNavController.tabBarItem = UITabBarItem(title: "API 키", image: UIImage(systemName: "key"), selectedImage: UIImage(systemName: "key.fill"))

        // 내정보 뷰 컨트롤러 생성 및 탭 바 아이템 설정
        let profileVC = ProfileViewController()
        let myInfoNavController = UINavigationController(rootViewController: profileVC)
        myInfoNavController.tabBarItem = UITabBarItem(title: "내정보", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        // 탭 바 컨트롤러에 내비게이션 컨트롤러를 추가
        self.viewControllers = [homeNavController, apiKeyNavController, myInfoNavController]
        self.tabBar.tintColor = .label
    }
}

