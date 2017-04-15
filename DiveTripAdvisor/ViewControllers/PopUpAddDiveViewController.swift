//
//  PopUpAddDiveViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 14/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class PopUpAddDiveViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var hasChanges: Bool = false
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    var locations: [Location] = []
    
    
    
    var user: User!
    
    var userUpdateUrl: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/updateUserInfo"
        }
    }
    
    /*  var userUrl: String {
     get {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     var curUser = DataService.getUser().id!
     print(curUser)
     return "\(appDelegate.baseUrl)/users/" + DataService.getUser().id!
     }
     }
     
     var locationsUpdateUrl: String {
     get {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     return "\(appDelegate.baseUrl)/locations/update"
     }
     }*/
    
    /* func getUser () {
     self.http?.delegate = self
     self.http?.get(fromUrl: self.userUrl)
     }
     
     @IBAction func update(_ sender: UIButton) {
     self.http?.delegate = self
     let username = self.user.username
     self.http?.postJson(toUrl: self.userUrl, withBody:
     ["username": username!,
     "id": self.user.id!,
     "logs": self.user.logs ?? [],
     "firstName": self.user.firstName ?? "",
     "lastName" : self.user.lastName ?? "",
     "description": self.user.userDescription ?? "",
     "imageUrl": self.user.imageUrl ?? "https://period4respiratorycase6.wikispaces.com/space/showlogo/1304984043/logo.gif"], andHeaders: ["authorization": UserDefaults.standard.value(forKey: "token") as! String])
     }*/
    
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
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   self.getUser()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
