//
//  SearchTableViewController.swift
//  iBike_home
//
//  Created by CY0290 on 2020/5/22.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchTableViewController: UITableViewController, UISearchResultsUpdating{
    
    var result: [uBikeData] = []
    var mySearchController: UISearchController?
    var searchPosition: [String] = []
    var bike: [uBikeData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        searchBar.delegate = self
        getbikeData()
        settingSearchController()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (mySearchController?.isActive)! {
            return result.count
        } else {
            return bike.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchTableViewCell
        
        let results = ((mySearchController?.isActive)!) ? result[indexPath.row] : bike[indexPath.row]
        cell.textLabel?.text = results.Position
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //performSegue(withIdentifier: "SeguePush", sender: Any?.self)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeguePush"{
            //獲取被點擊的cell值
            if let indexPath = self.tableView.indexPathForSelectedRow{
                //傳值
                let marker = segue.destination as! SearchPositionViewController
                marker.markLat = Double(bike[indexPath.row].Y)
                marker.markLong = Double(bike[indexPath.row].X)
                marker.markPosition = bike[indexPath.row].Position
            }
            
            
        }
        
    }
    
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
                                self.searchPosition.append(bikeData.Position)
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
    
    
    func filterContent(searchText: String){
        
        result = bike.filter({ (filterArray) -> Bool in
            
            let position = filterArray
            let isMach = position.Position.localizedCaseInsensitiveContains(searchText)
            
            return isMach
        })
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            tableView.reloadData()
        }
    }
    
    
    func settingSearchController(){
        mySearchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = mySearchController?.searchBar
        mySearchController?.searchResultsUpdater = self
        mySearchController?.searchBar.placeholder = "Search Words"
        mySearchController?.searchBar.barTintColor = .white
        mySearchController?.searchBar.tintColor = .black
        mySearchController?.searchBar.searchBarStyle = .prominent
        mySearchController?.dimsBackgroundDuringPresentation = false
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
    
    
}
