//
//  ViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 30/03/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, HttpRequesterDelegate {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    let defaults = UserDefaults.standard
    
    var appDelegate: AppDelegate {
        get {
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    var url: String {
        get{
            return "\(self.appDelegate.baseUrl)/authenticate"
        }
    }
    
    var http: HttpRequester? {
        get {
            
            return self.appDelegate.http
        }
    }
    
    func loginUser () {
        self.http?.delegate = self
        self.http?.postJson(toUrl: self.url, withBody: ["username": emailInput.text!, "password" : passwordInput.text!])
    }
    
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10

        super.viewDidLoad()
    }
    
    func storeUser(loggedUser: User){
        // test
        let context = self.appDelegate.persistentContainer.viewContext
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
    
    func didReceiveData(data: Any) {
        if let response = data as? Dictionary<String,Any> {
            let loggedUser =  User(dictionary: response["user"] as! [String: Any])
            let token = response["token"] as! String
            defaults.setValue(token, forKey: "token")
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabsVC = storyboard.instantiateViewController(withIdentifier: "tabs")
                self.storeUser(loggedUser: loggedUser)
                self.appDelegate.user = loggedUser
                
                self.appDelegate.navigationController?.pushViewController(tabsVC, animated: true)

            }
            
        }
    }
    
    func didReceiveError(error: HttpError) {
        print(error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var emailInput: UITextField!

    @IBOutlet var passwordInput: UITextField!
    @IBAction func login(_ sender: UIButton) {
        
        if let _ = emailInput.text, let _ = passwordInput.text  {
            loginUser()
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        

    }
}

