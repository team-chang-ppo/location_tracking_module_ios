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
        // apikey delete 요청
        stub(condition: { request -> Bool in
            // DELETE 메소드와 올바른 URL 경로 확인
            guard request.httpMethod == "DELETE",
                  let url = request.url,
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let lastPathComponent = components.path.components(separatedBy: "/").last,
                  let _ = Int(lastPathComponent)  // 마지막 경로 부분이 정수인지 확인
            else {
                return false
            }
            
            // 경로가 "/api/apikeys/v1/[int]" 포맷과 일치하는지 확인
            return components.path.starts(with: "/api/apikeys/v1/")
        }) { request -> HTTPStubsResponse in
            // 성공적인 JSON 응답 생성
            let response = """
            {
              "success": true,
              "code": "0"
            }
            """
            return HTTPStubsResponse(data: response.data(using: .utf8)!, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        // apikeylist 요청
        stub(condition: { request in
            // URL을 구성 요소로 파싱
            guard let url = request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
            }
            
            let isCorrectPath = components.path == "/api/apikeys/v1/member/me"
            
            let queryItems = components.queryItems?.reduce(into: [String: String]()) { (result, item) in
                result[item.name] = item.value
            } ?? [:]
            
            let isFirstApiKeyIdCorrect = queryItems["firstApiKeyId"] == "1"
            let isSizeCorrect = queryItems["size"] == "5"
            
            return isCorrectPath && isFirstApiKeyIdCorrect && isSizeCorrect
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
          "createdAt": "2024-05-06T18:46:51"
        },
        {
          "id": 2,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjIsImlhdCI6MTcxMjM5Njg3NH0.4-rkAD1S_k_aL-KwibEnfFafaSIGpsDYd-DYEyb3aJY",
          "grade": "GRADE_CLASSIC",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-05-07T18:47:54"
        },
        {
          "id": 3,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjMsImlhdCI6MTcxMjM5Njg3NX0.MvJbASaXWiyvmcrkwGmZ5TfjDLAQtlhlkLu-7-bt_Kc",
          "grade": "GRADE_PREMIUM",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-05-08T18:47:55"
        },
        {
          "id": 4,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjQsImlhdCI6MTcxMjM5Njg3Nn0.c3nvpkqfjeIKpZeQpIcxJU7GBZUvLMWMVN8OSgqVLCc",
          "grade": "GRADE_FREE",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-05-09T18:47:56"
        },
        {
          "id": 5,
          "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjUsImlhdCI6MTcxMjM5Njg3N30.HBlGwa2FFj_sVJf3KXXkzx9y8owxyOfe9gYsVLLpaJg",
          "grade": "GRADE_PREMIUM",
          "paymentFailureBannedAt": null,
          "cardDeletionBannedAt": null,
          "createdAt": "2024-05-10T18:47:57"
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
            return (request.url?.absoluteString == "\(Config.serverURL)api/members/v1/me?")
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
      "profileImage": "https://picsum.photos/id/232/200/300",
      "roles": [
        "ROLE_NORMAL"
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
            return (request.url?.absoluteString == "\(Config.serverURL)api/cards/v1/member/me?")
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
          "bin": "1111-1111-1111-1111",
          "paymentGateway": "PG_KAKAOPAY",
          "createdAt": "2024-04-06T18:49:39"
        },
        {
          "id": 2,
          "type": "신용",
          "issuerCorporation": "현대",
          "bin": "2222-2222-2222-2222",
          "paymentGateway": "PG_KAKAOPAY",
          "createdAt": "2024-04-06T18:49:39"
        },
        {
          "id": 3,
          "type": "신용",
          "issuerCorporation": "NH농협",
          "bin": "3333-3333-3333-3333",
          "paymentGateway": "PG_KAKAOPAY",
          "createdAt": "2024-04-06T18:49:39"
        },
        {
          "id": 4,
          "type": "신용",
          "issuerCorporation": "롯데",
          "bin": "4444-4444-4444-4444",
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

