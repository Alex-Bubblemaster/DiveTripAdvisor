//
//  Location.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 08/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import Foundation

class Location {
    let id: String?
    let name: String?
    let logs: [Any]?
    
    init (dictionary: [String: Any]) {
        
        self.id = dictionary["_id"] as? String
        self.name = (dictionary["name"] as? String)
        self.logs = (dictionary["logs"] as? [Any])
    }
    
    init(id: String?, name: String?, logs: [Any]?) {
        self.id = id
        self.name=name
        self.logs=logs
    }
}
