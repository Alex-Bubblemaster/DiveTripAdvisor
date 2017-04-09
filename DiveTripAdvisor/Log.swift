//
//  Log.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 30/03/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import Foundation

class Log {
    let location: String?
    let depth: Int?
    let time: Int?
    let sightings: [String]?
    let site: String?
    
    init (dictionary: [String: Any]) {
        self.location = (dictionary["location"] as? String)
        self.depth = (dictionary["depth"] as? Int)
        self.time = (dictionary["time"] as? Int)
        self.sightings = (dictionary["sightings"] as? [String])
        self.site = dictionary["site"] as? String
    }

    init(location: String?, depth: Int?, time: Int?,sightings: [String]?, site: String?) {
        self.location=location
        self.depth=depth
        self.time=time
        self.sightings=sightings
        self.site=site
    }
}
