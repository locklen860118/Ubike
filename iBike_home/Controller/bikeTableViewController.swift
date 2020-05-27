//
//  bikeTableViewController.swift
//  iBike_home
//
//  Created by CY0290 on 2020/5/17.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces
class bikeTableViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .white
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bike.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell") as! bikeTableViewCell
       
            cell.position.text = bike[indexPath.row].Position
            cell.carea.text = bike[indexPath.row].CArea
            cell.address.text = bike[indexPath.row].CAddress
            cell.available.text = bike[indexPath.row].AvailableCNT
            cell.updatetime.text = bike[indexPath.row].UpdateTime
            cell.distance.text = Stringdistance[indexPath.row]
            cell.pos.text = "站名："
            cell.area.text = "地區："
            cell.add.text = "地址："
            cell.ava.text = "剩餘數量："
            cell.dis.text = "距離"
            cell.date.text = "更新時間："
            cell.meter.text = "M"
            return cell
    }
}
