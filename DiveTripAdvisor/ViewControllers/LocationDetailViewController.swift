//
//  LocationDetailsViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 02/05/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController {
    
    var location: Location? = nil
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var imageOne: UIImageView!
    override func viewDidLoad() {
        self.name.text! = (self.location?.name)!
        self.longitude.text! = String(describing: (self.location?.longitude!)!)
        self.latitude.text! = String(describing: (self.location?.latitude!)!)
        self.loadImages()
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double((self.location?.latitude)!), longitude: Double((self.location?.longitude)!))
        self.map.addAnnotation(annotation)
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadImages(){
        var images : [UIImage] = []
        
        if  (self.location?.imageUrls?.count)! > 0 {
            for imageUrlStr in (self.location?.imageUrls!)! {
                var currUrl = ""
                let result = imageUrlStr.range(of: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", options: .regularExpression)
                if result != nil {
                    currUrl = imageUrlStr
                    let url = URL(string: currUrl)
                    let data = try? Data(contentsOf: url!)
                    
                    if data != nil {
                        let image = UIImage(data: data!)
                        if image != nil {
                            images.append(image!)
                        }
                    }
                }
            }
        }
        
        let defaultImageOne = UIImage(named: "defaultDetailsLocationOne.jpg")
        let defaultImageTwo = UIImage(named: "defaultDetailsLocationTwo.jpg")
        
        if images.count < 2 {
            images.append(defaultImageOne!)
            images.append(defaultImageTwo!)
        }
        
        self.imageOne.animationImages = images
        self.imageOne.animationDuration = 5
        self.imageOne.startAnimating()
        
        self.imageOne.layer.cornerRadius = 5
        let coord = CLLocationCoordinate2DMake(Double((self.location?.latitude)!),Double((self.location?.longitude)!));
        let region = MKCoordinateRegionMakeWithDistance(coord, 200000, 200000);
        if (region.center.latitude >= -90) && (region.center.latitude <= 90) && (region.center.longitude >= -180) && (region.center.longitude <= 180){
            self.map.setRegion(region, animated: true)
            
            self.map.layer.cornerRadius = 5
            
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
