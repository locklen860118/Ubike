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
class SearchPositionViewController: UIViewController {
    
    var markLat: Double?
    var markLong: Double?
    var markPosition: String?
    @IBOutlet var mapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(markLat!), longitude: CLLocationDegrees(markLong!), zoom: 16.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(markLat!), longitude: CLLocationDegrees(markLong!))
        marker.map = self.mapView
        marker.title = markPosition
        
        let currentMarker = GMSMarker()
        currentMarker.position = CLLocationCoordinate2D(latitude: 24.163922, longitude: 120.637630)
        currentMarker.map = self.mapView
        currentMarker.title = "我的位置"
    }
}

