//
//  TrackingRequest.swift
//  LocationApp
//
//  Created by 승재 on 4/2/24.
//

import Foundation

struct TrackingRequest : Codable {
    let locations : Point
}


/*
 
 "locations": {
         "x": 333.333,
         "y": 333.333
     }
 
 */
