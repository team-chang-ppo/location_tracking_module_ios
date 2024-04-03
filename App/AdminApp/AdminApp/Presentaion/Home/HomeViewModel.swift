//
//  HomeViewModel.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//

import Foundation
import Combine

final class HomeViewModel {
    
    init(pageItem : [PagingItem], selectedPageItem : PagingItem? = nil){
        self.pageItem = CurrentValueSubject(pageItem)
        self.selectedPageItem = CurrentValueSubject(selectedPageItem)
    }
    
    // User Action -> input
    // Data-> Output
    let pageItem : CurrentValueSubject<[PagingItem],Never>
    let selectedPageItem : CurrentValueSubject<PagingItem?, Never>
    
    func didPageSelect(at indexPath : IndexPath){
        let item = pageItem.value[indexPath.item]
        selectedPageItem.send(item)
    }
}
