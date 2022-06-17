//
//  Rooms.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 03/05/2022.
//

import Foundation

// MARK: - Rooms

struct DomoticzRooms: Codable {
    let result: [DomoticzRoom]
    let status, title: String
}

// MARK: - Result

struct DomoticzRoom: Codable, Identifiable {
    let devices: Int
    let name, order, idx: String

    var id = UUID()

    enum CodingKeys: String, CodingKey {
        case devices = "Devices"
        case name = "Name"
        case order = "Order"
        case idx
    }
}
