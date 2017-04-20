//
//  Log.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 30/03/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import Foundation

class Log {
    var location: String?
    var depth: Int?
    var time: Int?
    var sightings: [String]?
    var site: String?
    
    init (dictionary: [String: Any]) {
        self.location = (dictionary["location"] as! String)
        if dictionary["depth"] is NSNumber {
            self.depth = Int(dictionary["depth"] as! NSNumber)
        } else {
            self.depth = Int(dictionary["depth"] as! String)
        }
        
        if dictionary["time"] is NSNumber {
            self.time = Int(dictionary["time"] as! NSNumber)
        } else {
            self.time = Int(dictionary["time"] as! String)
        }
        
        self.sightings = dictionary["sightings"] as? [String]
        self.site = dictionary["site"] as? String
    }
    
    init (){
    }
    
    init(location: String?, depth: Int?, time: Int?,sightings: [String]?, site: String?) {
        self.location = location
        self.depth = depth
        self.time = time
        self.sightings = sightings
        self.site = site
    }
}
