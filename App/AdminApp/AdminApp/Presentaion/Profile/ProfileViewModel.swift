//
//  ProfileViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation

final class ProfileViewModel {
    
    init(){
        
    }
    
    func logout(){
        KeychainManager.delete(key: "SessionID")
    }
}
