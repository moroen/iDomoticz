//
//  MQTT.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 09/06/2022.
//

import Foundation
import MQTTNIO

struct DomoticzPayload: Codable {
    let battery: Int
    let lastUpdate: String
    let rssi: Int
    let welcomeDescription, dtype, hwid, id: String
    let idx: Int
    let name: String
    let nvalue: Int
    let stype, svalue1, switchType: String
    let unit: Int

    enum CodingKeys: String, CodingKey {
        case battery = "Battery"
        case lastUpdate = "LastUpdate"
        case rssi = "RSSI"
        case welcomeDescription = "description"
        case dtype, hwid, id, idx, name, nvalue, stype, svalue1, switchType, unit
    }
}

extension DomoticzData {
    private func connectMQTT() {
        
    }
}
