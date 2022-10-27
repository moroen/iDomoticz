//
//  Temps.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 19/06/2022.
//

import Foundation

struct DomoticzTemps: Codable {
    let result: [DomoticzTempDefinition]
    // let status, title: String
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let domoticzTempDefinition = try? newJSONDecoder().decode(DomoticzTempDefinition.self, from: jsonData)

import Foundation
import SwiftUI

// MARK: - DomoticzTempDefinition
struct DomoticzTempDefinition: Codable {

    // let batteryLevel: Int
    // let data, domoticzTempDefinitionDescription, dewPoint: String
    // let favorite: Int
    // let hardwareDisabled: Bool
    // let hardwareID: Int
    // let hardwareName, hardwareType: String
    // let hardwareTypeVal, humidity: Int
    // let humidityStatus, id, lastUpdate, name: String
    let name: String
    // let planID: String
    //let planIDs: [Int]
    // let signalLevel: Int
    // let subType: String
    let temp: Double
    // let timers, type, typeImg: String
    // let unit, used: Int
    // let xOffset, yOffset: String
    let idx: String
    // let trend: Int

    enum CodingKeys: String, CodingKey {
        // case batteryLevel = "BatteryLevel"
        // case data = "Data"
        // case domoticzTempDefinitionDescription = "Description"
        // case dewPoint = "DewPoint"
        // case favorite = "Favorite"
        // case hardwareDisabled = "HardwareDisabled"
        // case hardwareID = "HardwareID"
        // case hardwareName = "HardwareName"
        // case hardwareType = "HardwareType"
        // case hardwareTypeVal = "HardwareTypeVal"
        // case humidity = "Humidity"
        // case humidityStatus = "HumidityStatus"
        // case id = "ID"
        // case lastUpdate = "LastUpdate"
        case name = "Name"
        // case planID = "PlanID"
        // case planIDs = "PlanIDs"
        // case signalLevel = "SignalLevel"
        // case subType = "SubType"
        case temp = "Temp"
        // case timers = "Timers"
        // case type = "Type"
        // case typeImg = "TypeImg"
        // case unit = "Unit"
        // case used = "Used"
        // case xOffset = "XOffset"
        // case yOffset = "YOffset"
        case idx //,trend
    }
}

class DomoticzSensor: ObservableObject, Identifiable {
    var id = UUID()
    public var idx: String?
    @Published var name: String?
    @Published var value: String?
    public var type: String?
}

class DomoticzTemp: DomoticzSensor {
    // @Published var info: DomoticzTempDefinition

    init(definition: DomoticzTempDefinition) {
        super.init()
        self.idx = definition.idx
        self.name = definition.name
        self.value = String(definition.temp)
        self.type = "Temp"
    }
}

extension DomoticzData {
    public func GetTemps() -> Void {
        
        guard let URL = URL(string: "\(self.settings.domoticzConfig.server)/json.htm?type=devices&filter=temp&used=true&order=Name")
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
                print("Unabe to let temps data")
                return
            }

            guard let all = try? JSONDecoder().decode(DomoticzTemps.self, from: data)
            else {
                print("Temps decoder failed")
                return
            }

            DispatchQueue.main.async {
                all.result.forEach { res in
                    let row = self.sensors.firstIndex(where: { $0.idx == res.idx })
                    if row == nil {
                        self.sensors.append(DomoticzTemp(definition: res))
                    } else {
                        self.sensors[row!] = DomoticzTemp(definition: res)
                    }
                }
            }
        }.resume()
    }

}

struct TempButton: View {
    @ObservedObject var temp: DomoticzSensor
    private var name: Text

    init(temp: DomoticzSensor) {
        self.temp = temp
        name = Text(temp.name!)
    }

    var body: some View {
        Button(action: {
            
        }) {
            HStack {
                Image(systemName: "thermometer")
                #if os(tvOS)
                HStack {
                        // name.modifier(FitToWidth(fraction: 1))
                    name
                    Spacer()
                    Text(temp.value!+"°C")
                }
                #else
                HStack {
                    name
                    Spacer()
                    Text(String(temp.value!)+"°C")
                }
                
                #endif

            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

struct TempsList: View {
    let temps: [DomoticzSensor]

    var body: some View {
        ForEach(temps) { temp in
            TempButton(temp: temp)
        }
    }
}
