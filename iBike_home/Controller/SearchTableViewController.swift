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

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
