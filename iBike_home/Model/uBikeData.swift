//
//  TaichungJsonData.swift
//  iBike_home
//
//  Created by CY0290 on 2020/5/13.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleMaps

struct uBikeData: Decodable {
    var Position: String
    var X : Float
    var Y : Float
    var CArea : String
    var CAddress : String
    var AvailableCNT: String
    var UpdateTime : String
}

//MARK: -> read jsaon
var  bike: [uBikeData] = []
var mark: [uBikeData] = []
var Stringdistance: [String] = []

func GetBikeData( bikeJsonData:  @escaping( _ position: String, _ lat: Float, _ long: Float, _ distance: Double, _ AvailableCNT: String, _ CArea: String, _ CAddress: String, _ UpdateTime: String) ->Void ){
    
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
                            bike.append(bikeData)

                            let currentLocation = CLLocation (latitude: 24.163922, longitude: 120.637630)
                            let targetLocation =  CLLocation (latitude: CLLocationDegrees(bikeData.Y), longitude: CLLocationDegrees(bikeData.X))
                            let distance: CLLocationDistance  = currentLocation.distance(from: targetLocation)
                            let intdistance = Int(distance)
                            let stringdistance = String(intdistance)
                            
                            Stringdistance.append(stringdistance)
                            
                            bikeJsonData(bikeData.Position, bikeData.Y, bikeData.X, distance, bikeData.AvailableCNT, bikeData.CArea, bikeData.CAddress, bikeData.UpdateTime)
                        }
                    }
                }
            }
        }.resume()
    } else {
        print("Invalid URL.")
    }
    
}





