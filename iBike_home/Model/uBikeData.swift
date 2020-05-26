//
//  TaichungJsonData.swift
//  iBike_home
//
//  Created by CY0290 on 2020/5/13.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

struct uBikeData: Decodable {
    var Position: String
    var X : Float
    var Y : Float
    var CArea : String
    var CAddress : String
    var AvailableCNT: String
    var UpdateTime : String
}
