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
    let userDescription: String?
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
        self.userDescription = dictionary["description"] as? String
        self.logs = (dictionary["logs"] as? [Log])!
        self.imageUrl = dictionary["imageUrl"] as? String
        
    }
    
    init (firstName: String?, lastName: String?, email: String?, id: String?, imageUrl: String?,userDescription: String?,logs :[Log], confirmPassword: String?,username: String?,password: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
        self.imageUrl = imageUrl
        self.userDescription = userDescription
        self.logs = logs
        self.confirmPassword = confirmPassword
        self.username = username
        self.password = password
    }
}
