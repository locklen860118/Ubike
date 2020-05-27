//
//  ViewController.swift
//  iBike_home
//
//  Created by Chris on 2020/5/12.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var googleMapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var searchController: UISearchController?
    private var myLocationManager = CLLocationManager()
    var menuOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawMarker()
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        googleMapView.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        myLocationManager.delegate = self
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
            self.view.layoutIfNeeded()}){(animationComplete)in
            print("ok")
        }
    }
    
    //MARK: -> Marker
    
    func drawMarker(){
        GetBikeData { (position, lat, long, distance, availableCNT, carea, caddress, updatetime) in
            if distance <= 1500{
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                marker.map = self.googleMapView
                marker.title = position
                marker.snippet = "剩餘數量:\(availableCNT)"
            }
        }
    }
}


extension ViewController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        myLocationManager.startUpdatingLocation()
        googleMapView.isMyLocationEnabled = true
        //googleMapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        myLocationManager.stopUpdatingLocation()
    }
    
    //確認點擊哪個marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        GetBikeData { (position, lat, long, distance, avaliableCNT, crea, caddress, updatetime) in
            if marker.title == position{
                print("地點：\(position)")
                print("marker:\(String(describing: marker.title))")
            }
        }
        mapView.selectedMarker = marker
        return true
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







