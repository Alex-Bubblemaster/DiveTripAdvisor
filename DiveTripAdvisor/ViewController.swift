//
//  ViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 30/03/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HttpRequesterDelegate {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var user: User!
    
    var url: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/authenticate"
        }
    }
    
    var http: HttpRequester? {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    func loginUser () {
        self.http?.delegate = self
        
        self.http?.postJson(toUrl: self.url, withBody: ["username": emailInput.text!, "password" : passwordInput.text!])
        print(["username": emailInput.text!, "password" : passwordInput.text!])
    }
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
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

