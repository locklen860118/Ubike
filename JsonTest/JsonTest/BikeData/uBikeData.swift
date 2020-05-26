// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct uBikeData: Codable {
    let id, position, eName: String
    let x, y: Double
    let cArea, eArea, cAddress, eAddress: String
    let availableCNT, empCNT: Int
    let updateTime: UpdateTime

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case position = "Position"
        case eName = "EName"
        case x = "X"
        case y = "Y"
        case cArea = "CArea"
        case eArea = "EArea"
        case cAddress = "CAddress"
        case eAddress = "EAddress"
        case availableCNT = "AvailableCNT"
        case empCNT = "EmpCNT"
        case updateTime = "UpdateTime"
    }
}

enum UpdateTime: String, Codable {
    case the20200513230904 = "2020-05-13 23:09:04"
}

typealias UbikeData = [uBikeData]
