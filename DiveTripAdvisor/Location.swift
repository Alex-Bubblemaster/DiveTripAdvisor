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
    var logs: [Log]?
    var latitude : Int?
    var longitude: Int?
    var sites: [[String:Any]]?
    var imageUrls : [String]?
    
    
    init (dictionary: [String: Any]) {
        
        self.id = dictionary["_id"] as? String
        self.name = (dictionary["name"] as? String)
        self.logs = parseLogs(logs: dictionary["logs"] as! [[String:Any]])
        self.imageUrls = (dictionary["imageUrls"] as! [String])
        self.latitude = dictionary["latitude"] as? Int
        self.longitude = dictionary["longitude"] as? Int
        self.sites = dictionary["sites"] as? [[String:Any]]
    }
    
   /* init(id: String?, name: String?, logs: [Log]?) {
        self.id = id
        self.name=name
        self.logs=logs
    }*/
    
    func parseLogs(logs :[[String: Any]]) -> [Log] {
        var locationLogs : [Log] = []
        for log in logs {
            locationLogs.append(Log(dictionary: log))
        }
        return locationLogs
    }
    
    func logsToJsonCompatible() -> [[String: Any]]{
        
        return self.logs!.map() {
            return $0.logAsJSONcompatible()
        }
        
    }

}
