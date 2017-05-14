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
    
    var loginUrl: String {
        get{
            return "\(self.appDelegate.baseUrl)/authenticate"
        }
    }
    
    var registerUrl: String {
        get{
            return "\(self.appDelegate.baseUrl)/signup"
        }
    }
    
    var http: HttpRequester? {
        get {
            
            return self.appDelegate.http
        }
    }
    
    var dataService: DataService {
        get {
            return self.appDelegate.dataService
        }
    }
    
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        
        super.viewDidLoad()
    }
    
    
    func didReceiveData(data: Any) {
        if let response = data as? Dictionary<String,Any> {
            
            DispatchQueue.main.async {
                let user =  User(dictionary: response["user"] as! [String: Any])
                let token = response["token"] as! String
                self.defaults.setValue(token, forKey: "token")
                self.defaults.setValue(user.id, forKey: "id")
                self.dataService.storeUser(loggedUser: user)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabsVC = storyboard.instantiateViewController(withIdentifier: "tabs")
                self.appDelegate.navigationController?.pushViewController(tabsVC, animated: true)
            }
        }
    }
    
    func didReceiveError(error: HttpError) {
        DispatchQueue.main.async {
            let errorMessage = String(describing: error).replacingOccurrences(of: "api(\"", with: "").replacingOccurrences(of: "\")", with: "")
            
            let uiAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
           
            uiAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(uiAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet var emailInput: UITextField!
    
    @IBOutlet var passwordInput: UITextField!
    @IBAction func login(_ sender: UIButton) {
        if let _ = emailInput.text, let _ = passwordInput.text  {
            self.http?.delegate = self
            self.http?.postJson(toUrl: self.loginUrl, withBody: ["username": emailInput.text!, "password" : passwordInput.text!])        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        if let _ = emailInput.text, let _ = passwordInput.text  {
            self.http?.delegate = self
            self.http?.postJson(toUrl: self.registerUrl,
                                withBody: ["username": emailInput.text!,
                                           "password" : passwordInput.text!,
                                           "confirmPassword": passwordInput.text!,
                                           "email": emailInput.text!])
        }
    }
}
