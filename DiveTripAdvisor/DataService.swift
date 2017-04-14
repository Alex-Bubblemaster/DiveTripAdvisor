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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
        request.returnsObjectsAsFaults = false
        do {
            let users = try context.fetch(request)
            if users.count > 0 {
                for user in users as! [NSManagedObject]{
                    if user.value(forKey: "username") as? String == loggedUser.username {
                        user.setValue(loggedUser.lastName, forKey: "lastName")
                        user.setValue(loggedUser.userDescription, forKey: "userDescription")
                        user.setValue(loggedUser.firstName, forKey: "firstName")
                        user.setValue(loggedUser.imageUrl, forKey: "imageUrl")
                        user.setValue(loggedUser.username, forKey: "username")
                        print(user.value(forKey:"lastName") ?? "defaultUpdate")
                    }
                }
            }
            
        } catch {
            print("Update Failed")
        }
    }
    
    class func getUser() -> User {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
        let loggedUser = User()
        
        request.returnsObjectsAsFaults = false
        do {
            let users = try context.fetch(request)
            if users.count > 0 {
                for user in users as! [NSManagedObject]{
                    if let username = user.value(forKey: "username") as? String {
                        loggedUser.username = username                    }
                    if let lastName = user.value(forKey: "lastName") as? String {
                        loggedUser.lastName=lastName
                    }
                    if let imageUrl = user.value(forKey: "imageUrl") as? String {
                        loggedUser.imageUrl=imageUrl
                    }
                    if let appUserDescription = user.value(forKey: "userDescription") as? String {
                        loggedUser.userDescription=appUserDescription
                    }
                    if let firstName = user.value(forKey: "firstName") as? String {
                        loggedUser.firstName=firstName
                    }
                }
            }
            
        } catch {
            print("Fetching Failed")
        }
        return loggedUser
    }
    
    func storeUser(loggedUser: User){
        // test
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into:  context)
        //AppUser(context: context) // Link Task & Context
        newUser.setValue(loggedUser.lastName, forKey: "lastName")
        newUser.setValue(loggedUser.id, forKey: "id")
        newUser.setValue(loggedUser.userDescription, forKey: "userDescription")
        newUser.setValue(loggedUser.firstName, forKey: "firstName")
        newUser.setValue(loggedUser.imageUrl, forKey: "imageUrl")
        newUser.setValue(loggedUser.username, forKey: "username")
        
        do {
            try context.save()
        }
        catch{
        }
    }
    
}


