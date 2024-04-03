//
//  APIKeyViewModel.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import Foundation
import Combine

final class APIKeyViewModel {
    
    init(APIItem : [APICard], selectedAPIItem : APICard? = nil){
        self.APIItem = CurrentValueSubject(APIItem)
        self.selectedAPIItem = CurrentValueSubject(selectedAPIItem)
    }
    // User Action -> input
    let APIItem : CurrentValueSubject<[APICard], Never>
    let selectedAPIItem : CurrentValueSubject<APICard?, Never>
    
    func didAPISelect(at indexPath : IndexPath){
        let item = APIItem.value[indexPath.item]
        selectedAPIItem.send(item)
    }
    
}
