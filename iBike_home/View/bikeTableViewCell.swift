//
//  bikeTableViewCell.swift
//  iBike_home
//
//  Created by CY0290 on 2020/5/17.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit


class bikeTableViewCell: UITableViewCell {
    

    @IBOutlet weak var meter: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var dis: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ava: UILabel!
    @IBOutlet weak var add: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var pos: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var carea: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var updatetime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
