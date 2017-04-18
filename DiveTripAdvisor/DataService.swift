//
//  DataService.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 14/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataService {
    
    var appDelegate: AppDelegate {
        get {
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    var context: NSManagedObjectContext {
        get {
            return self.appDelegate.persistentContainer.viewContext
        }
    }
    
    func updateUser(loggedUser: User){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
        request.returnsObjectsAsFaults = false
        do {
            let users = try self.context.fetch(request)
            if users.count > 0 {
                for user in users as! [NSManagedObject]{
                    if user.value(forKey: "username") as? String == loggedUser.username {
                        user.setValue(loggedUser.lastName, forKey: "lastName")
                        user.setValue(loggedUser.userDescription, forKey: "userDescription")
                        user.setValue(loggedUser.firstName, forKey: "firstName")
                        user.setValue(loggedUser.imageUrl, forKey: "imageUrl")
                        user.setValue(loggedUser.username, forKey: "username")
                        user.setValue(loggedUser.email, forKey: "email")
                        user.setValue(loggedUser.id, forKey: "userId")
                    }
                }
            }
            
        } catch {
            print("Update Failed")
        }
    }
    
    func getUser() -> AppUser {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
        do {
            let fetchedPerson = try self.context.fetch(userFetch)
            return fetchedPerson[0] as! AppUser
        } catch {
        }
        
        return AppUser()
    }
    
    func storeUser(loggedUser: User){
        
        let appUserEntity = NSEntityDescription.entity(forEntityName: "AppUser", in:  self.context)
        let newUser: AppUser = AppUser(entity: appUserEntity!, insertInto: self.context)
        
        newUser.id = loggedUser.id
        newUser.lastName = loggedUser.lastName
        newUser.userDescription = loggedUser.userDescription
        newUser.firstName = loggedUser.firstName
        newUser.imageUrl = loggedUser.imageUrl
        newUser.username = loggedUser.username
        newUser.email = loggedUser.email
        
        for log in loggedUser.logs!  {
            
            let appLogEntity = NSEntityDescription.entity(forEntityName: "AppLog", in:  self.context)
            let newAppLog: AppLog = AppLog(entity: appLogEntity!, insertInto: self.context)
            
            newAppLog.depth = Int16(log.depth!)
            newAppLog.time = Int16(log.time!)
            newAppLog.location = log.location
            newAppLog.site = log.site
            newAppLog.diverId = newUser.id
            newUser.addToLog(newAppLog)
            
            for sighting in log.sightings! {
                let appSightingEntity = NSEntityDescription.entity(forEntityName: "AppSighting", in:  self.context)
                let newSighting: AppSighting = AppSighting(entity: appSightingEntity!, insertInto: self.context)
                
                newSighting.name = sighting
                
                newSighting.addToLog(newAppLog)
                newAppLog.addToSighting(newSighting)
            }
        }
        
        do {
            try self.context.save()
        }
        catch{
        }
    }
}


