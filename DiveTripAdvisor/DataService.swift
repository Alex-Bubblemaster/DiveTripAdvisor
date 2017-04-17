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
        // userFetch.predicate = NSPredicate(format: "userid == %@", userid)
        var loggedUser = AppUser()

        do {
            let fetchedPerson = try self.context.fetch(userFetch)
            loggedUser = fetchedPerson[0] as! AppUser
        } catch {
            
        }
        /*let requestUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
         let requestLogs = NSFetchRequest<NSFetchRequestResult>(entityName: "AppLogs")
         let requestSightings = NSFetchRequest<NSFetchRequestResult>(entityName: "AppSighting")
                  let loggedUserLogs : [Log] = []
         
         
         requestUsers.returnsObjectsAsFaults = false
         requestLogs.returnsObjectsAsFaults = false
         requestSightings.returnsObjectsAsFaults = false
         do {
         let users = try self.context.fetch(requestUsers)
         let logs = try self.context.fetch(requestUsers)
         let sightings = try self.context.fetch(requestUsers)
         
         
         if users.count > 0 {
         if logs.count > 0 {
         for log in logs as! [NSManagedObject]{
         if let location = log.value(forKey: "location") as? String {
         let log = Log()
         log.location = location
         }
         }
         
         }
         for user in users as! [NSManagedObject]{
         if let username = user.value(forKey: "username") as? String {
         loggedUser.username = username                    }
         if let lastName = user.value(forKey: "lastName") as? String {
         loggedUser.lastName=lastName
         }
         if let imageUrl = user.value(forKey: "imageUrl") as? String {
         loggedUser.imageUrl = imageUrl
         }
         if let appUserDescription = user.value(forKey: "userDescription") as? String {
         loggedUser.userDescription=appUserDescription
         }
         if let firstName = user.value(forKey: "firstName") as? String {
         loggedUser.firstName = firstName
         }
         if let userId = user.value(forKey: "userId") as? String {
         loggedUser.id = userId
         }
         if let email = user.value(forKey: "email") as? String {
         loggedUser.email = email
         }
         }
         }
         
         } catch {
         print("Fetching Failed")
         }*/
        
        return loggedUser
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


