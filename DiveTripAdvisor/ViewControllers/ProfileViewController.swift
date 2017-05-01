//
//  ProfileViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 09/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController : UIViewController, HttpRequesterDelegate, UserSentDataDelegate {
    
    func userDidEnterData() {
        self.populateTextFields()
    }
    
    var appDelegate: AppDelegate {
        get {
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    var dataService : DataService {
        get {
            return (self.appDelegate.dataService)
        }
    }
    
    var storedUserId: String {
        get {
            return UserDefaults.standard.value(forKey: "id") as! String
        }
    }
    
    
    var user: AppUser {
        get {
            return self.dataService.getUser(id: storedUserId)!
        }
    }
    
    var http: HttpRequester? {
        get {
            return self.appDelegate.http
        }
    }
    
    var locationsUrl: String {
        get{
            return "\(self.appDelegate.baseUrl)/locations/read"
        }
    }
    
    var locations: [Location]? = nil
    
    @IBOutlet weak var addDiveBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        addDiveBtn.layer.cornerRadius = 10
        editBtn.layer.cornerRadius = 10
        self.populateTextFields()
        self.loadLocations()
        super.viewDidLoad()
    }
    
    func populateTextFields(){
        username.text = self.user.username
        let url = URL(string: self.user.imageUrl ?? "https://period4respiratorycase6.wikispaces.com/space/showlogo/1304984043/logo.gif" )
        let data = try? Data(contentsOf: url!)
        image.image = UIImage(data: data!)
        firstName.text = self.user.firstName ?? "Unknown"
        lastName.text = self.user.lastName ?? "Unknown"
        userDescription.text = self.user.userDescription ?? "Diver"
    }
    
    func loadLocations () {
        self.http?.delegate = self
        self.http?.get(fromUrl: self.locationsUrl)
    }
    
    func didReceiveData(data: Any) {
        if let array = data as? [String: Any] {
            if let dataArray = array["data"] as? [Dictionary<String, Any>] {
                self.locations = dataArray.map(){Location(dictionary: $0)}
                    .filter{$0.name != ""}
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPopup" {
            let sendingVC: PopUpViewController = segue.destination as! PopUpViewController
            sendingVC.userUpdateDelegate = self
        }
        
        if segue.identifier == "addDivePopup" && (self.locations?.count)! > 0 {
            let sendingVC: PopUpAddDiveViewController = segue.destination as! PopUpAddDiveViewController
            sendingVC.locations = self.locations!
            sendingVC.userUpdateDelegate = self
            
        }
    }
    
}
