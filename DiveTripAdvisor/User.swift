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
    var email: String?
    
    init (dictionary: [String: Any]) {
        
        self.id = dictionary["id"] as? String
        self.username = dictionary["username"] as? String
        self.firstName = dictionary["firstName"] as? String ?? "Unknown"
        self.lastName  = dictionary["lastName"] as? String ?? "Unknown"
        self.userDescription = dictionary["description"] as? String ?? "Diver"
        self.logs = parseLogs(logs: dictionary["logs"] as! [[String:Any]])
        self.imageUrl = dictionary["imageUrl"] as? String ?? "https://period4respiratorycase6.wikispaces.com/space/showlogo/1304984043/logo.gif"
        self.email = dictionary["email"] as? String
        
    }
    
    init(){
        self.imageUrl = "https://period4respiratorycase6.wikispaces.com/space/showlogo/1304984043/logo.gif"
        self.userDescription = "Diver"
    }
    
    init (firstName: String?, lastName: String?, email: String?, id: String?, imageUrl: String?,userDescription: String?,logs :[Log]?,username: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.imageUrl = imageUrl
        self.userDescription = userDescription
        self.logs = logs
        self.username = username
        self.email = email
    }
    
    func parseLogs(logs :[[String: Any]]) -> [Log] {
        var userLogs : [Log] = []
        for log in logs {
            userLogs.append(Log(dictionary: log))
        }
        return userLogs
    }
}
