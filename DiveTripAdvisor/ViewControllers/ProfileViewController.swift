//
//  ProfileViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 09/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController : UIViewController, HttpRequesterDelegate {
    
    var dataService : DataService {
        get {
            return DataService()
        }
    }
    var user: AppUser {
        get {
            return self.dataService.getUser()
        }
    }
    
    var http: HttpRequester? {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    var locationsUrl: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/locations/read"
        }
    }
    
    func loadLocations () {
        self.http?.delegate = self
        self.http?.get(fromUrl: self.locationsUrl)
    }
    
    @IBOutlet weak var addDiveBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        print(self.user)
        username.text = self.user.username
        let url = URL(string: self.user.imageUrl ?? "https://period4respiratorycase6.wikispaces.com/space/showlogo/1304984043/logo.gif" )
        let data = try? Data(contentsOf: url!)
        image.image = UIImage(data: data!)
        firstName.text = self.user.firstName ?? "Unknown"
        lastName.text = self.user.lastName ?? "Unknown"
        userDescription.text = self.user.userDescription ?? "Diver"
        addDiveBtn.layer.cornerRadius = 10
        editBtn.layer.cornerRadius = 10
        
        super.viewDidLoad()
    }
    
    @IBAction func addDive(_ sender: UIButton) {
        loadLocations()
    }
    
    @IBAction func edit() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    func didReceiveData(data: Any) {
        if let array = data as? [String: Any] {
            if let dataArray = array["data"] as? [Dictionary<String, Any>] {
                let locations = dataArray.map(){Location(dictionary: $0)}
                    .filter{$0.name != ""}
                DispatchQueue.main.async {
                    let popOverDiveVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpAddDive") as! PopUpAddDiveViewController
                    popOverDiveVC.locations = locations
                    self.addChildViewController(popOverDiveVC)
                    
                    popOverDiveVC.view.frame = self.view.frame
                    self.view.addSubview(popOverDiveVC.view)
                    popOverDiveVC.didMove(toParentViewController: self)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
