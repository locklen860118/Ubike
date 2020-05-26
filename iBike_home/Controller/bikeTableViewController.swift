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
        getbikeData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bike.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell") as! bikeTableViewCell
        
        cell.position.text = bike[indexPath.row].Position
        cell.carea.text = bike[indexPath.row].CArea
        cell.address.text = bike[indexPath.row].CAddress
        cell.available.text = bike[indexPath.row].AvailableCNT
        cell.updatetime.text = bike[indexPath.row].UpdateTime
        cell.distance.text = stringdistance[indexPath.row]
        cell.pos.text = "站名："
        cell.area.text = "地區："
        cell.add.text = "地址："
        cell.ava.text = "剩餘數量："
        cell.dis.text = "距離"
        cell.date.text = "更新時間："
        cell.meter.text = "M"
        return cell
    }
    
    // MARK: - JSON
    var bike: [uBikeData] = []
    var stringdistance:[String] = []
    func getbikeData(){
       let address = "http://e-traffic.taichung.gov.tw/DataAPI/api/YoubikeAllAPI"
        
        
        if let url = URL(string: address) {
            // GET
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // 假如錯誤存在，則印出錯誤訊息
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    // 檢查http狀態
                    print("Status code: \(response.statusCode)")
                    DispatchQueue.main.async {
                            let json = try? JSON(data: data)
                            if let bikeJson = json?.arrayValue{
                              for data in bikeJson{
                              //轉型+存取至陣列
                                let bikeData = uBikeData.init( Position: data["Position"].stringValue, X: data["X"].floatValue, Y: data["Y"].floatValue, CArea: data["CArea"].stringValue, CAddress: data["CAddress"].stringValue, AvailableCNT: data["AvailableCNT"].stringValue, UpdateTime: data["UpdateTime"].stringValue)
                                self.bike.append(bikeData)
                                
                                let  currentLocation =  CLLocation (latitude: 24.163913, longitude: 120.637649)
                                let  targetLocation =  CLLocation (latitude: CLLocationDegrees(bikeData.Y), longitude: CLLocationDegrees(bikeData.X))
                                let  distance: CLLocationDistance  = currentLocation.distance(from: targetLocation)
                                let intdistance = Int(distance)
                                self.stringdistance.append(String(intdistance))
                            }
                                
                            self.tableView.reloadData()
                        }
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
