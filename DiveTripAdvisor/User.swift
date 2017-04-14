//
//  User.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 30/03/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import Foundation

class User {
    
    var id: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var userDescription: String?
    var imageUrl: String?
    var logs :[Log]?
    
    init (dictionary: [String: Any]) {
        
        self.id = dictionary["id"] as? String
        self.username = dictionary["username"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.lastName  = dictionary["lastName"] as? String
        self.userDescription = dictionary["description"] as? String
        self.logs = (dictionary["logs"] as? [Log])!
        self.imageUrl = dictionary["imageUrl"] as? String
        
    }
    
    init(){
    }
    
    init (firstName: String?, lastName: String?, email: String?, id: String?, imageUrl: String?,userDescription: String?,logs :[Log]?,username: String?,password: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.imageUrl = imageUrl
        self.userDescription = userDescription
        self.logs = logs
        self.username = username
    }
}
