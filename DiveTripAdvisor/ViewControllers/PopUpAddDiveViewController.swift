//
//  PopUpAddDiveViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 14/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import CoreData

class PopUpAddDiveViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, HttpRequesterDelegate {
    
    var userUpdateDelegate: UserSentDataDelegate? = nil
    var locations: [Location] = []
    var selectedLocation: Location?
    var storedUserId: String {
        get {
            return UserDefaults.standard.value(forKey: "id") as! String
        }
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
    var user: AppUser {
        get {
            return self.dataService.getUser(id: storedUserId)!
        }
    }
    
    var newLog: Log = Log()
    
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
    
    var didReceiveUserUpdate:Bool = false
    var didReceiveLocationUpdate:Bool = false
    
    
    @IBOutlet weak var sightings: UITextView!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var site: UITextField!
    @IBOutlet weak var depth: UITextField!
    @IBOutlet weak var duration: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func saveDive(_ sender: UIButton) {
        createDive()
    }
    
    func updateLocation(){
        
        let newLogAsJson = self.newLog.logAsJSONcompatible()
        var locationLogs = self.selectedLocation!.logsToJsonCompatible()
        locationLogs.append(newLogAsJson)
        print("location logs")
        print(locationLogs)
        self.http?.delegate = self
        self.http?.postJson(toUrl: self.locationsUpdateUrl, withBody:
            [ "_id" : self.selectedLocation?.id! as Any,
              "name" : self.selectedLocation?.name ?? "Unknown",
              "latitude": self.selectedLocation?.latitude! ?? 0,
              "longitude": self.selectedLocation?.longitude! ?? 0,
              "sites": self.selectedLocation?.sites ?? [["name": "Unknown"]],
              "imageUrls": self.selectedLocation?.imageUrls ?? ["https://img.rezdy.com/PRODUCT_IMAGE/29234/lion%20fish_med.jpg"],
              "logs": locationLogs ],
                            andHeaders: ["authorization": UserDefaults.standard.value(forKey: "token") as! String])
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
            updateUser()
        }
    }
    
    func updateUser(){
        var jsonCompatibleArray = self.dataService.getUserLogs()
        jsonCompatibleArray.append(self.newLog.logAsJSONcompatible())
        
        self.http?.delegate = self
        self.http?.postJson(toUrl: self.userUpdateUrl, withBody:
            [ "firstName" : self.user.firstName ?? "Unknown",
              "lastName" : self.user.lastName ?? "Unknown",
              "email": self.user.email ?? "Unknown",
              "imageUrl":self.user.imageUrl!,
              "description": self.user.userDescription ?? "Open Water Diver",
              "username": self.user.username!,
              "id": self.user.id!,
              "logs": jsonCompatibleArray ],
                            andHeaders: ["authorization": UserDefaults.standard.value(forKey: "token") as! String])
        
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
        self.selectedLocation = self.locations[row]
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
    
    
    override func viewDidLoad() {
        self.cancelBtn.layer.cornerRadius = 10
        self.saveBtn.layer.cornerRadius = 10
        self.sightings.layer.cornerRadius = 10
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didReceiveData(data: Any) {
        if let response = data as? Dictionary<String,Any> {
            
            if response["user"] != nil {
                didReceiveUserUpdate = true
                updateLocation()
            }
            
            if response["location"] != nil {
                didReceiveLocationUpdate = true
            }
        }
        if self.userUpdateDelegate != nil && didReceiveUserUpdate == true && didReceiveLocationUpdate == true {
            self.dataService.createLogForUser(loggedUser: self.user, newLog: newLog)
            self.userUpdateDelegate?.userDidEnterData()
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
