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
    override func viewDidLoad() {
        self.name.text! = (self.location?.name)!
        self.longitude.text! = String(describing: (self.location?.longitude!)!)
        self.latitude.text! = String(describing: (self.location?.latitude!)!)
        print(String(describing:self.location?.longitude!))
        self.loadImages()
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadImages(){
        /*
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
         */
        var images : [UIImage] = []
        if (self.location?.imageUrls?.count)! > 0 {
            for imageUrl in (self.location?.imageUrls!)! {
                var currUrl = ""
                let result = imageUrl.range(of: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", options: .regularExpression)
                if(result == nil){
                    currUrl = "http://www.momodivecenter.com/wp-content/uploads/thumb33.png"
                } else {
                 currUrl = imageUrl
                }
                let url = URL(string: currUrl)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                images.append(image!)
            }
        }
        
        
        let defaultImageUrlOne = URL(string: "http://www.seasthedayscuba.com/wp-content/uploads/2016/04/dive_flag.jpg")
        let defaultDataOne = try? Data(contentsOf:defaultImageUrlOne!)
        let defaultImageOne = UIImage(data:defaultDataOne!)
        
        let defaultImageUrlTwo = URL(string: "https://s-media-cache-ak0.pinimg.com/736x/ae/fb/23/aefb23d8c2fd55c4cb43c85b3b881561.jpg")
        let defaultDataTwo = try? Data(contentsOf:defaultImageUrlTwo!)
        let defaultImageTwo = UIImage(data:defaultDataTwo!)
        
        if images.count < 2 {
            images.append(defaultImageOne!)
            images.append(defaultImageTwo!)
        }
        
        
        
        self.imageOne.animationImages = images
        self.imageOne.animationDuration = 5
        self.imageOne.startAnimating()
        
        self.imageOne.layer.cornerRadius = 10
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
