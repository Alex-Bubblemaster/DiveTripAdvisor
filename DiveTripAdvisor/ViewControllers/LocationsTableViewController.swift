//
//  LocationsTableViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 09/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit


class LocationsTableViewController: UITableViewController, HttpRequesterDelegate {
    
    @IBOutlet weak var uitbView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locations: [Location] = []
    
    var url: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/locations/read"
        }
    }
    
    var http: HttpRequester? {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    func loadLocations () {
        self.activityIndicator.startAnimating()
        self.http?.delegate = self
        self.http?.get(fromUrl: self.url)
    }
    
    override func viewDidLoad() {
        self.loadLocations()
        super.viewDidLoad()
    }
    
    func didReceiveData(data: Any) {
        if let array = data as? [String: Any] {
            if let dataArray = array["data"] as? [Dictionary<String, Any>] {
                self.locations = dataArray.map(){Location(dictionary: $0)}
                    .filter{$0.name != ""}
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    func showDetails(of location: Location){
        let locationDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "locationDetails") as! LocationDetailViewController
        locationDetailsVC.location = location
        DispatchQueue.main.async {
            self.navigationController?.show(locationDetailsVC, sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "location-cell", for: indexPath) as! LocationCellTableViewCell
        
        var remoteImageUrlString = "https://www.divetrip.com/tawali/turtlediver.jpg"
        
        if  (self.locations[indexPath.row].imageUrls?.count)! > 0 {
            remoteImageUrlString = self.locations[indexPath.row].imageUrls![0]
        }
        let imageUrl = NSURL(string: remoteImageUrlString )
        let defaultImage = UIImage(named: "location.jpg")
        
        myCell.locationImageView?.sd_setImage(with: imageUrl! as URL, placeholderImage: defaultImage)
        myCell.locationLabel.text = self.locations[indexPath.row].name
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails(of: self.locations[indexPath.row])
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

