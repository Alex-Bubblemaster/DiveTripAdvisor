//
//  LogsTableViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 08/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class LogsTableViewController: UITableViewController, HttpRequesterDelegate {
    
    var locations: [Location] = []
    var logs: [Log] = []
    var appDelegate: AppDelegate {
        get {
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    var url: String {
        get{
            return "\(self.appDelegate.baseUrl)/locations/read"
        }
    }
    
    var http: HttpRequester? {
        get{
            return self.appDelegate.http
        }
    }
    
    func loadLogs () {
        self.http?.delegate = self
        self.http?.get(fromUrl: self.url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLogs()
    }
    
    func didReceiveData(data: Any) {
        if let array = data as? [String: Any] {
            if let dataArray = array["data"] as? [Dictionary<String, Any>] {
                self.locations = dataArray.map(){Location(dictionary: $0)}
                self.locations.forEach({ (location) in
                    if let logsArray = location.logs {
                        if logsArray.count > 0 {
                            self.logs.append(contentsOf: logsArray)
                        }
                    }
                })
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.logs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "log-cell", for: indexPath) as! LogsTableViewCell
        cell.siteName?.text = self.logs[indexPath.row].site
        cell.siteName?.layer.cornerRadius = 5
        cell.depth?.text = String(self.logs[indexPath.row].depth!) + " m"
        cell.time?.text = String(self.logs[indexPath.row].time!) + " mins"
        cell.locationName?.text = self.logs[indexPath.row].location
        // Configure the cell...
        
        return cell
    }
}
