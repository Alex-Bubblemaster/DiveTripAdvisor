//
//  ProfileViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 09/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController : UIViewController {
    
    var user: User {
        get {
            return DataService.getUser()
        }
    }
    @IBOutlet weak var addDive: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        username.text = self.user.username
        let url = URL(string: self.user.imageUrl!)
        let data = try? Data(contentsOf: url!)
        image.image = UIImage(data: data!)
        firstName.text = self.user.firstName
        lastName.text = self.user.lastName
        userDescription.text = self.user.userDescription
        addDive.layer.cornerRadius = 10
        editBtn.layer.cornerRadius = 10
        
        super.viewDidLoad()
    }
    
    @IBAction func edit() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
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
