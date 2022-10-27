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

extension DomoticzData {
    func GetRooms() {
        guard let URL = URL(string: "\(self.settings.domoticzConfig.server)/json.htm?type=plans&order=name&used=true")
        else {
            print("Unable to set temps URL")
            return
        }
        
        URLSession.shared.dataTask(with: URL) { data, _, error in
            if let error = error {
                print(error)
                return
            }

            guard let data = data
            else {
                print("Unabe to let rooms data")
                return
            }

            guard let allRooms = try? JSONDecoder().decode(DomoticzRooms.self, from: data)
            else {
                print("Rooms decoder failed")
                return
            }

            DispatchQueue.main.async {
                self.rooms = allRooms.result
            }

        }.resume()
        
    }
}
