//
//  User.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 30/03/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import Foundation

class User {
    
    let id: String?
    let username: String?
    let password: String?
    let confirmPassword: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let description: String?
    let imageUrl: String?
    let logs :[Log]
    
    init (dictionary: [String: Any]) {
        
        self.id = dictionary["id"] as? String
        self.username = dictionary["username"] as? String
        self.password = dictionary["password"] as? String
        self.confirmPassword = dictionary["confirmPassword"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.lastName  = dictionary["lastName"] as? String
        self.email = dictionary["email"] as? String
        self.description = dictionary["description"] as? String
        self.logs = (dictionary["logs"] as? [Log])!
        if let pictureDict = dictionary["imageUrl"] as? [String: Any] {
            if let dataDict = pictureDict["data"] as? [String: Any] {
                self.imageUrl = dataDict["url"] as? String
                return
            }
        }
        self.imageUrl = ""
    }
    
    init (firstName: String?, lastName: String?, email: String?, id: String?, imageUrl: String?,description: String?,logs :[Log], confirmPassword: String?,username: String?,password: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
        self.imageUrl = imageUrl
        self.description = description
        self.logs = logs
        self.confirmPassword = confirmPassword
        self.username = username
        self.password = password
    }
}
