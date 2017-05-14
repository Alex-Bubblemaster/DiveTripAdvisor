//
//  MyLogsTableViewController.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 18/04/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit
import CoreData

class MyLogsTableViewController: UITableViewController {

    var dataService : DataService {
        get {
            return self.appDelegate.dataService
        }
    }
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    var userLogs: [Log] {
        get {
            let logsAsJson = self.dataService.getUserLogs()
            var userLogs: [Log] = []
            for log in logsAsJson {
                userLogs.append(Log(dictionary: log))
            }
            return userLogs
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.userLogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "my-logs", for: indexPath) as! MyLogsTableViewCell
        cell.site?.text = self.userLogs[indexPath.row].site
        cell.site?.layer.cornerRadius = 5
        cell.depth?.text = String(self.userLogs[indexPath.row].depth!) + " m"
        cell.time?.text = String(self.userLogs[indexPath.row].time!) + " mins"
        cell.locationName?.text = self.userLogs[indexPath.row].location
        cell.sightings?.text = "Sightings: " + (self.userLogs[indexPath.row].sightings?.joined(separator: ", "))!
        cell.sightings?.layer.cornerRadius = 5


        return cell
    }
}
