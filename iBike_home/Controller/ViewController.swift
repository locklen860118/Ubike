//
//  ViewController.swift
//  iBike_home
//
//  Created by Chris on 2020/5/12.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate,GMSMapViewDelegate{
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var googleMapView: GMSMapView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var placesClient: GMSPlacesClient!
    var searchController: UISearchController?
    var myLocationManager :CLLocationManager!
    private let locationManager = CLLocationManager()
    var menuOut = false
    var bike: [uBikeData] = []
    var bikeMarker: [GMSMarker] = []
    var lastMarker: GMSMarker?
    //var mark: uBikeData?
    var mark: [uBikeData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBikeData()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        googleMapView.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    //MARK: -> 使用者權限
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction( title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
    }
    
    //MARK: -> Menu Buttom
    @IBAction func menuTapped(_ sender: Any) {
        if menuOut == false{
            leading.constant = 180
            trailing.constant = 0
            menuOut = true
        }else{
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }){(animationComplete)in
            print("ok")
        }
    }
    
    
    //MARK: -> User Updatelocation
    /*
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0] as CLLocation
        MARK: -> marker in map
        for dis in self.bike{
            let lat = dis.X
            let long = dis.Y
            let currentLocation = CLLocation (latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let targetLocation =  CLLocation (latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            let distance: CLLocationDistance  = currentLocation.distance(from: targetLocation)
            
            
            if distance <= 1500{
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                marker.map = self.googleMapView
                marker.title = "\(dis.Position)"
                marker.snippet = "剩餘數量:\(dis.AvailableCNT)"
                marker.snippet = "距離:\(Int(distance))公尺"
                print( "地點：\(dis.Position),兩點間距離是：\(distance)" )
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        print(currentLocation.coordinate.latitude)
        print(currentLocation.coordinate.longitude)
    }
    */
    //MARK: -> read jsaon
    
    
    func getBikeData() {
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
                                //print("Posotion:" + bikeData.Position)
                                
                                let currentLocation = CLLocation (latitude: 24.163922, longitude: 120.637630)
                                let targetLocation =  CLLocation (latitude: CLLocationDegrees(bikeData.Y), longitude: CLLocationDegrees(bikeData.X))
                                let distance: CLLocationDistance  = currentLocation.distance(from: targetLocation)
                                if distance <= 1500{
                                    let marker = GMSMarker()
                                    marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(bikeData.Y), longitude: CLLocationDegrees(bikeData.X))
                                    marker.map = self.googleMapView
                                    // marker.icon = GMSMarker.markerImage(with: .blue)
                                    marker.title = "\(bikeData.Position)"
                                    marker.snippet = "剩餘數量:\(bikeData.AvailableCNT)"
                                    //self.bikeMarker.append(marker)
                                    
                                    
                                    
                                    
                                    let markdata = uBikeData(Position: bikeData.Position, X: bikeData.Y, Y: bikeData.X, CArea: bikeData.CArea, CAddress: bikeData.CAddress, AvailableCNT: bikeData.AvailableCNT, UpdateTime: bikeData.UpdateTime)
                                    self.mark.append(markdata)
                                    //print(self.mark[0].Position)              
                                }
                                //print(self.bikeMarker)
                            }
                            //print("地點:\(self.markertitle)")
                        }
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
}



extension ViewController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //print("地點:\(self.markertitle)")
        
        for index in 0...self.mark.count-1 {
            if marker.title == self.mark[index].Position{
                //marker.title = "地點：\(self.mark[0].Position)"
                print("地點：\(String(describing: self.mark[index].X))")
                print("marker:\(String(describing: marker.title))")
                //marker.icon = GMSMarker.markerImage(with: .blue)
                
            }
            
        }
        mapView.selectedMarker = marker
        return true
    }
    
}


