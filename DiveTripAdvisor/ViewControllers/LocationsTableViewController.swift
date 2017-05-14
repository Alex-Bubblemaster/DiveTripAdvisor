//
//  LocationsTableViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 09/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import Foundation

class LocationsTableViewController: UITableViewController, HttpRequesterDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
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
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredTableData = [Location]()
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: resultSearchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        if(searchText != ""){
            self.filteredTableData = self.locations.filter { location in
                return (location.name?.localizedLowercase.contains(searchText.localizedLowercase))!
            }
            self.tableView.reloadData()
        } else {
            self.filteredTableData = self.locations
            self.tableView.reloadData()
        }
    }
    
    func loadLocations () {
        self.activityIndicator.startAnimating()
        self.http?.delegate = self
        self.http?.get(fromUrl: self.url)
    }
    
    override func viewDidLoad() {
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = resultSearchController.searchBar
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
        if self.resultSearchController.isActive {
            return self.filteredTableData.count
        }else{
            return self.locations.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.tableView.dequeueReusableCell(withIdentifier: "location-cell", for: indexPath) as! LocationCellTableViewCell
        
        var remoteImageUrlString = "https://www.divetrip.com/tawali/turtlediver.jpg"
        
        let defaultImage = UIImage(named: "location.jpg")
        if self.resultSearchController.isActive {
            if  (self.filteredTableData[indexPath.row].imageUrls?.count)! > 0 {
                remoteImageUrlString = self.filteredTableData[indexPath.row].imageUrls![0]
                myCell.locationLabel?.text = self.filteredTableData[indexPath.row].name
            }
            
        } else {
            if  (self.locations[indexPath.row].imageUrls?.count)! > 0 {
                remoteImageUrlString = self.locations[indexPath.row].imageUrls![0]
                myCell.locationLabel?.text = self.locations[indexPath.row].name
            }
        }
        
        let imageUrl = NSURL(string: remoteImageUrlString )
        myCell.locationImageView?.sd_setImage(with: imageUrl! as URL, placeholderImage: defaultImage)
        myCell.locationImageView?.layer.cornerRadius = 5
        
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails(of: self.locations[indexPath.row])
    }
}
