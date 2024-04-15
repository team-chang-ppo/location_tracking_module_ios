//
//  SceneDelegate.swift
//  AdminApp
//
//  Created by 승재 on 3/15/24.
//

import UIKit
import OHHTTPStubs
import OHHTTPStubsSwift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
#if DEBUG
        stub(condition: { (request) -> Bool in
            return (request.url?.absoluteString == "\(Config.serverURL)/api/apikeys/v1/member/me")
        }) { request -> HTTPStubsResponse in
            let stubData = """
{
  "success": true,
  "code": "0",
  "result": {
    "data": {
      "numberOfElements": 5,
      "hasNext": true,
      "apiKeyList": [
        {
          "id": 1,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjEsImlhdCI6MTcxMjM5NjgxMX0.T8BAUfZU4b_i3AELLW8BZckFpAk2WB2jd8o4EtMwumg",
          "grade": "GRADE_FREE",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-04-06T18:46:51"
        },
        {
          "id": 2,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjIsImlhdCI6MTcxMjM5Njg3NH0.4-rkAD1S_k_aL-KwibEnfFafaSIGpsDYd-DYEyb3aJY",
          "grade": "GRADE_CLASSIC",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-04-06T18:47:54"
        },
        {
          "id": 3,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjMsImlhdCI6MTcxMjM5Njg3NX0.MvJbASaXWiyvmcrkwGmZ5TfjDLAQtlhlkLu-7-bt_Kc",
          "grade": "GRADE_PRIMIUM",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-04-06T18:47:55"
        },
        {
          "id": 4,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjQsImlhdCI6MTcxMjM5Njg3Nn0.c3nvpkqfjeIKpZeQpIcxJU7GBZUvLMWMVN8OSgqVLCc",
          "grade": "GRADE_FREE",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-04-06T18:47:56"
        },
        {
          "id": 5,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjUsImlhdCI6MTcxMjM5Njg3N30.HBlGwa2FFj_sVJf3KXXkzx9y8owxyOfe9gYsVLLpaJg",
          "grade": "GRADE_PRIMIUM",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-04-06T18:47:57"
        }
      ]
    }
  }
}
""".data(using: .utf8)
            return HTTPStubsResponse(data: stubData!, statusCode:200, headers:nil)
        }
        
        // user 정보 fetch
        stub(condition: { (request) -> Bool in
            return (request.url?.absoluteString == "\(Config.serverURL)/api/members/v1/me")
        }) { request -> HTTPStubsResponse in
            let stubData = """
{
  "success": true,
  "code": "0",
  "result": {
    "data": {
      "id": 1,
      "name": "kakao_3389504025",
      "username": "송제용",
      "profileImage": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
      "roles": [
        "ROLE_FREE"
      ],
      "paymentFailureBannedAt": null,
      "createdAt": "2024-04-06T20:15:57"
    }
  }
}
""".data(using: .utf8)
            return HTTPStubsResponse(data: stubData!, statusCode:200, headers:nil)
        }
        
        // card 정보 fetch
        stub(condition: { (request) -> Bool in
            return (request.url?.absoluteString == "\(Config.serverURL)/api/cards/v1/member/me")
        }) { request -> HTTPStubsResponse in
            let stubData = """
{
  "success": true,
  "code": "0",
  "result": {
    "data": {
      "cardList": [
        {
          "id": 1,
          "type": "신용",
          "issuerCorporation": "신한",
          "bin": "111111",
          "paymentGateway": "PG_KAKAOPAY",
          "createdAt": "2024-04-06T18:49:39"
        },
        {
          "id": 2,
          "type": "신용",
          "issuerCorporation": "현대",
          "bin": "222222",
          "paymentGateway": "PG_KAKAOPAY",
          "createdAt": "2024-04-06T18:49:39"
        }
      ]
    }
  }
}
""".data(using: .utf8)
            return HTTPStubsResponse(data: stubData!, statusCode:200, headers:nil)
        }
        
        // APIChart 정보 fetch
        stub(condition: { (request) -> Bool in
            return (request.url?.absoluteString == "\(Config.serverURL)/api/cards/v1/test")
        }) { request -> HTTPStubsResponse in
            let stubData = """
{
  "currency": "won",
  "totalAmount": 700,
  "apiKeys": [
    {
      "apiKey": "9798f4fd-6812-4cc5-9690-4acfcf9e8c9d",
      "charges": [
        {
          "date": "2024-04-01",
          "amount": 100
        },
        {
          "date": "2024-04-02",
          "amount": 150
        }
      ]
    },
    {
      "apiKey": "5194174c-9954-4dd9-aac2-8db541d15de4",
      "charges": [
        {
          "date": "2024-04-01",
          "amount": 200
        },
        {
          "date": "2024-04-02",
          "amount": 250
        }
      ]
    }
  ]
}
""".data(using: .utf8)
            return HTTPStubsResponse(data: stubData!, statusCode:200, headers:nil)
        }
#endif
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // 로그인이 된 경우
        if AuthManager.shared.isSignedIn {
            // 탭 바 컨트롤러 생성 및 설정
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
        } else {
            // 로그인 되지 않은 경우 로그인 뷰 컨트롤러를 보여줌
            let loginVC = LoginViewController()
            let navVC = UINavigationController(rootViewController: loginVC)
            navVC.navigationBar.prefersLargeTitles = true
            loginVC.navigationItem.title = "로그인"
            window?.rootViewController = navVC
        }
        window?.makeKeyAndVisible()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

