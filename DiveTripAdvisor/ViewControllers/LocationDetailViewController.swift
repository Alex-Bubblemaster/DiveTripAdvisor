//
//  LocationDetailsViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 02/05/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    var location: Location? = nil
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    override func viewDidLoad() {
        self.name.text! = (self.location?.name)!
        self.longitude.text! = String(describing: (self.location?.longitude!)!)
        self.latitude.text! = String(describing: (self.location?.latitude!)!)
        print(String(describing:self.location?.longitude!))
        self.loadImages()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages(){
        var urlOne = URL(string: "https://www.divetrip.com/tawali/turtlediver.jpg")
        var urlTwo = URL(string: "http://www.seasthedayscuba.com/wp-content/uploads/2016/04/dive_flag.jpg")
        let urlOneDefault = URL(string:"https://www.divetrip.com/tawali/turtlediver.jpg")
        let urlTwoDefault = URL(string: "http://www.seasthedayscuba.com/wp-content/uploads/2016/04/dive_flag.jpg")
        
        if (self.location?.imageUrls?.count)! > 0 {
            urlOne = URL(string: (self.location?.imageUrls?[0])!)
        }
        if(self.location?.imageUrls?.count)! > 1{
            urlTwo = URL(string: (self.location?.imageUrls?[1])!)
        }
        
        let dataOne = try? Data(contentsOf: urlOne ?? urlOneDefault!)
        if dataOne == nil{
            self.imageOne.image = UIImage(data: try! Data(contentsOf: urlOneDefault!))
        } else {
            self.imageOne.image = UIImage(data: dataOne!)
        }
        
        let dataTwo = try? Data(contentsOf: urlTwo ?? urlTwoDefault!)
        if dataTwo == nil{
            self.imageTwo.image = UIImage(data: try! Data(contentsOf: urlTwoDefault!))
        } else {
            self.imageTwo.image = UIImage(data: dataTwo!)
        }
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
