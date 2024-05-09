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
        let homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeNC.navigationBar.prefersLargeTitles = true
        
        

        // API 키 뷰 컨트롤러 생성 및 탭 바 아이템 설정
        let apiKeyVC = ApiKeyViewController()
        let apiKeyNC = UINavigationController(rootViewController: apiKeyVC)
        apiKeyNC.tabBarItem = UITabBarItem(
            title: "API 키",
            image: UIImage(systemName: "key"), selectedImage: UIImage(systemName: "key.fill"))
        apiKeyNC.navigationBar.prefersLargeTitles = true

        // 내정보 뷰 컨트롤러 생성 및 탭 바 아이템 설정
        let profileVC = ProfileViewController()
        let profileNC = UINavigationController(rootViewController: profileVC)
        profileNC.tabBarItem = UITabBarItem(
            title: "내정보",
            image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        profileNC.navigationBar.prefersLargeTitles = true

        self.viewControllers = [homeNC, apiKeyNC, profileNC]
        self.tabBar.tintColor = .label
    }
}

