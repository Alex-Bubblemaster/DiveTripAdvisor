//
//  PopUpViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 09/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController, HttpRequesterDelegate {
    var hasChanges: Bool = false
    var dataService : DataService {
        get{
            return DataService()
        }
    }
    
    var user: User {
        get {
            return DataService.getUser()
        }
    }
    
    var url: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/updateUserInfo"
        }
    }
    
    var http: HttpRequester? {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
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
        self.http?.delegate = self
        let username = self.user.username
        self.http?.postJson(toUrl: self.url, withBody:
            ["username": username!,
             "firstName": firstName.text!,
             "lastName" : lastName.text!,
             "description": userDescription.text!,
             "imageUrl": imageUrl.text!], andHeaders: ["authorization": UserDefaults.standard.value(forKey: "token") as! String])
    }
    
    func didReceiveData(data: Any) {
        if let response = data as? Dictionary<String,Any> {
            let loggedUser =  User(dictionary: response["user"] as! [String: Any])
            self.dataService.updateUser(loggedUser: loggedUser)
            hasChanges = true
            DispatchQueue.main.async {
                self.removeAnimate()
            }
        }
    }
    
    @IBAction func closePopUp() {
        self.removeAnimate()
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                if self.hasChanges == true {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabs = storyboard.instantiateViewController(withIdentifier: "tabs")
                    
                    (UIApplication.shared.delegate as! AppDelegate).navigationController?.pushViewController(tabs, animated: true)
                    tabs.view.removeFromSuperview();
                }
                self.view.removeFromSuperview()
            }
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
