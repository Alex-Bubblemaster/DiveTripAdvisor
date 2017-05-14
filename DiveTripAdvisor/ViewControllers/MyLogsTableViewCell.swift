//
//  MyLogsTableViewCell.swift
//  DiveTripAdvisor
//
//  Created by Alexandrina Hajigeorgieva on 14/05/2017.
//  Copyright © 2017 Alexandrina Hajigeorgieva. All rights reserved.
//

import UIKit

class MyLogsTableViewCell: UITableViewCell {

    @IBOutlet weak var sightings: UILabel!
    @IBOutlet weak var depth: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var site: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
