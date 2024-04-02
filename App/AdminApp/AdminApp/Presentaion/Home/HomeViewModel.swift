//
//  HomeViewModel.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//

import Foundation
import Combine

final class HomeViewModel {
    
    init(pageItem : [PagingItem], APIItem : [APICard], selectedAPIItem : APICard? = nil, selectedPageItem : PagingItem? = nil){
        self.pageItem = CurrentValueSubject(pageItem)
        self.APIItem = CurrentValueSubject(APIItem)
        self.selectedAPIItem = CurrentValueSubject(selectedAPIItem)
        self.selectedPageItem = CurrentValueSubject(selectedPageItem)
    }
    
    // User Action -> input
    let APIItem : CurrentValueSubject<[APICard], Never>
    // Data-> Output
    let pageItem : CurrentValueSubject<[PagingItem],Never>
    let selectedAPIItem : CurrentValueSubject<APICard?, Never>
    let selectedPageItem : CurrentValueSubject<PagingItem?, Never>
    
    func didAPISelect(at indexPath : IndexPath){
        let item = APIItem.value[indexPath.item]
        selectedAPIItem.send(item)
    }
    
    func didPageSelect(at indexPath : IndexPath){
        let item = pageItem.value[indexPath.item]
        selectedPageItem.send(item)
    }
    
    
    func logout(){
        KeychainManager.delete(key: "SessionID")
    }
    
}
