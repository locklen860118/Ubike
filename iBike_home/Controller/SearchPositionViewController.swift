//
//  SearchPositionViewController.swift
//  iBike_home
//
//  Created by Chris on 2020/5/23.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import GooglePlaces

class SearchPositionViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var markLat: Double?
    var markLong: Double?
    var markPosition: String?
    @IBOutlet var mapView: GMSMapView!
    private var myLocationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        mapView.delegate = self
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(markLat!), longitude: CLLocationDegrees(markLong!))
        marker.map = self.mapView
        marker.title = markPosition

        getdirectionData()
    }
    //MARK: ->規劃路線 
    
    func getdirectionData(){
        
        let address = "https://maps.googleapis.com/maps/api/directions/json?origin=24.163922,120.637630&destination=\(CLLocationDegrees(markLat!)),\(CLLocationDegrees(markLong!))&mode=walking&key=AIzaSyDXjp9kHdptSw1SICxeNS1FnQPRqq8oSgw"
        
        if let url = URL(string: address) {
            print(url)
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
                        let routes = json!["routes"].arrayValue
                        //print(type(of: routes))
                        for route in routes
                        {
                            let routeOverviewPolyline = route["overview_polyline"].dictionary
                            let points = routeOverviewPolyline?["points"]?.stringValue
                            let path = GMSPath.init(fromEncodedPath: points!)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.map = self.mapView
                        }
                    }
                }
            }.resume()
        }
    }
}



extension SearchPositionViewController {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        myLocationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        myLocationManager.stopUpdatingLocation()
    }
}
