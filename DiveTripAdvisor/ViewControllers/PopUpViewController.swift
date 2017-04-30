//
//  PopUpViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 09/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController, HttpRequesterDelegate {
    var userUpdateDelegate: UserSentDataDelegate? = nil
    var dataService : DataService {
        get {
            return self.appDelegate.dataService
        }
    }
    var storedUserId: String {
        get {
            return UserDefaults.standard.value(forKey: "id") as! String
        }
    }
    
    
    var user: AppUser {
        get {
            return self.dataService.getUser(id: self.storedUserId)!
        }
    }
    
    var appDelegate : AppDelegate {
        get{
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    var url: String {
        get{
            return "\(self.appDelegate.baseUrl)/updateUserInfo"
        }
    }
    
    var http: HttpRequester? {
        get{
            return self.appDelegate.http
        }
    }
    
    override func viewDidLoad() {
        cancel.layer.cornerRadius = 10
        save.layer.cornerRadius = 10
        imageUrl.text = self.user.imageUrl
        firstName.text = self.user.firstName
        lastName.text = self.user.lastName
        userDescription.text = self.user.userDescription
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
    }
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userDescription: UITextField!
    @IBOutlet weak var imageUrl: UITextField!
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var save: UIButton!
    
    @IBAction func update(_ sender: UIButton) {
        let userLogs : [[String:Any]] = self.dataService.getUserLogs()
        let data = ["username": self.user.username!,
                    "logs": userLogs,
                    "id": self.user.id!,
                    "email": self.user.email!,
                    "firstName": firstName.text ?? "Unknown",
                    "lastName" : lastName.text ?? "Unknown",
                    "description": userDescription.text ?? "Diver",
                    "imageUrl": imageUrl.text ?? "https://period4respiratorycase6.wikispaces.com/space/showlogo/1304984043/logo.gif"] as [String : Any]
        
        self.http?.delegate = self
        self.http?.postJson(toUrl: self.url, withBody: data, andHeaders: ["authorization": UserDefaults.standard.value(forKey: "token") as! String])
    }
    
    func didReceiveData(data: Any) {
        if let response = data as? Dictionary<String,Any> {
            let loggedUser =  User(dictionary: response["user"] as! [String: Any])
            self.dataService.updateUserInfo(loggedUser: loggedUser)
            
            if self.userUpdateDelegate != nil {
                self.userUpdateDelegate?.userDidEnterData()
            }
            
        }
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
