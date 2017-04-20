//
//  PopUpAddDiveViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 14/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class PopUpAddDiveViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, HttpRequesterDelegate {
    
    var hasChanges: Bool = false
    var locations: [Location] = []
    
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

    var newLog: Log = Log()
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    var userUpdateUrl: String {
        get {
            return "\(self.appDelegate.baseUrl)/updateUserInfo"
        }
    }
    var locationsUpdateUrl: String {
        get {
            return "\(self.appDelegate.baseUrl)/locations/update"
        }
    }
    var http: HttpRequester? {
        get {
            return self.appDelegate.http
        }
    }
    
    @IBOutlet weak var sightings: UITextView!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var site: UITextField!
    @IBOutlet weak var depth: UITextField!
    @IBOutlet weak var duration: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBAction func cancelDive(_ sender: UIButton) {
        // TODO: Check close popup
        self.removeAnimate()
    }
    
    @IBAction func saveDive(_ sender: UIButton) {
        createDive()
        updateUser()
        // wait/async
        
        //update location
        
        // close popup
    }
    
    func createDive(){
        if addDiveFormIsValid() {
            if let sightingsText = self.sightings.text {
                let mappedSightings = sightingsText.components(separatedBy: ",")
                self.newLog.sightings = mappedSightings
            }
            self.newLog.depth = Int(self.depth.text!)
            self.newLog.time = Int(self.duration.text!)
            self.newLog.location = self.textBox.text!
            self.newLog.site = self.site.text!
            
            self.dataService.createLogForUser(loggedUser: self.user, newLog: newLog)
        }
    }
    
    func addDiveFormIsValid() -> Bool{
        if (self.depth.text?.characters.count)! > 0
            && (self.duration.text?.characters.count)! > 0
            && (self.textBox.text?.characters.count)! > 0
            && (self.site.text?.characters.count)! > 0 {
            return true
        }
        return false
    }
    
    func updateUser(){
        
        let diveLogJSON = self.user.log!.allObjects as! [AppLog]
        let jsonCompatibleArray = diveLogJSON.map { log in
            return [
                "location":log.location!,
                "depth":log.depth,
                "time":log.time,
                "site":log.site!,
                "sightings": (log.sighting?.allObjects as![AppSighting]).map { String(describing: $0)}
            ]
        }
        print(jsonCompatibleArray)
        self.http?.delegate = self
        self.http?.postJson(toUrl: self.userUpdateUrl, withBody:
            [ "firstName" : self.user.firstName ?? "Unknown",
              "lastName" : self.user.lastName ?? "Unknown",
              "email": self.user.email ?? "Unknown",
              "imageUrl":self.user.imageUrl!,
              "description": self.user.userDescription ?? "Open Water Diver",
              "username": self.user.username!,
              "id": self.user.id!,
              "logs": jsonCompatibleArray], andHeaders: ["authorization": UserDefaults.standard.value(forKey: "token") as! String])
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return self.locations.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return self.locations[row].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textBox.text = self.locations[row].name
        self.dropDown.isHidden = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textBox {
            self.dropDown.isHidden = false
            textField.endEditing(true)
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
                    
                    self.appDelegate.navigationController?.pushViewController(tabs, animated: true)
                    tabs.view.removeFromSuperview();
                }
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    override func viewDidLoad() {
        self.cancelBtn.layer.cornerRadius = 10
        self.saveBtn.layer.cornerRadius = 10
        self.sightings.layer.cornerRadius = 10
        super.viewDidLoad()
        // self.saveBtn.isUserInteractionEnabled = false
        /* self.depth.delegate = self
         self.textBox.delegate = self
         self.duration.delegate = self
         self.site.delegate = self*/
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didReceiveData(data: Any) {
        if data is Dictionary<String,Any> {
            DispatchQueue.main.async {
                self.removeAnimate()
            }
        }
    }
    func didReceiveError(error: HttpError) {
        print(error)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
