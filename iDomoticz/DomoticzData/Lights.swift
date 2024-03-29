//
//  Devices.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 03/05/2022.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let domoticzLights = try? newJSONDecoder().decode(DomoticzLights.self, from: jsonData)

import Foundation
import SwiftUI

// MARK: - Lights

struct DomoticzLights: Codable {
    let result: [DomoticzLightDefinition]
    // let status, title: String
}

// MARK: - Result

struct DomoticzLightDefinition: Codable, Identifiable, DomoticzDeviceDefinition {
    let name, idx, planID: String
    var status: String
    let switchType: String
    let switchTypeCode, level: Int
    let favorite: Int

    var id = UUID()

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case planID = "PlanID"
        case favorite = "Favorite"
        case switchType = "SwitchType"
        case switchTypeCode = "SwitchTypeVal"
        case level = "Level"
        case status = "Status"
        case idx
    }
}

class DomoticzLight: DomoticzDevice, Identifiable {
    
    var id = UUID()

    init(definition: DomoticzLightDefinition) {
        super.init(definition: definition)
        if info.switchTypeCode == 7, info.status != "Off" {
            info.status = info.level > 0 ? "On" : "Off"
        }
    }

    public func ToggleStatus() {
        info.status = info.status == "On" ? "Off" : "On"
        setStatus(status: info.status)
    }
    
    override public func setStatus(status: String) {
        let cmd = "type=command&param=switchlight&idx=\(info.idx)&switchcmd=\(status)"
        print(cmd)
        DomoticzData.shared.DoJsonCommand(cmd: cmd)
        if !Settings().mqttConfig.enabled {
            print("Manual status update")
            self.updateStatus(status: status)
        }
    }
}

extension DomoticzData {
    public func GetLights() -> Void {
        guard let lightsURL = URL(string: "\(self.settings.domoticzConfig.server)/json.htm?type=devices&filter=light&used=true")
        else {
            print("Unable to set lights URL")
            return
        }
                
        URLSession.shared.dataTask(with: lightsURL) { data, _, error in
            if let error = error {
                print(error)
                return
            }

            guard let data = data
            else {
                print("Unabe to let lights data")
                return
            }

            guard let allLights = try? JSONDecoder().decode(DomoticzLights.self, from: data)
            else {
                print("Devices decoder failed")
                return
            }

            DispatchQueue.main.async {
                allLights.result.forEach { res in
                    let row = self.lights.firstIndex(where: { $0.info.idx == res.idx })
                    if row == nil {
                        self.lights.append(DomoticzLight(definition: res))
                    } else {
                        self.lights[row!] = DomoticzLight(definition: res)
                    }
                }
            }

        }.resume()
    }

}
// Views
struct LightButton: View {
    @ObservedObject var light: DomoticzLight

    @State var displaySize: CGFloat = .zero
    @State var fraction: CGFloat = .zero

    private var Name: Text

    init(light: DomoticzLight) {
        self.light = light
        Name = Text(light.info.name)
    }

    var body: some View {
        Button(action: {
            light.ToggleStatus()
        }) {
            HStack {
                StateImageBuilder(state: light.info.status)
                #if os(tvOS)
                    Name.modifier(FitToWidth(fraction: 1))
                #else
                    Name
                #endif

            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
    /*
     Button(action: {
     light.ToggleStatus()
     }) {
     HStack {
     StateImageBuilder(state: light.info.status )
     VStack {
     Text(light.info.name)
     .frame(maxWidth: .infinity, alignment: .leading)
     // .modifier(FitToWidth(fraction: 1))
     /*
      HStack {
      Text(light.info.switchType)
      .frame(maxWidth: .infinity, alignment: .leading)
      Text(light.info.switchTypeCode.description)
      .frame(maxWidth: .infinity, alignment: .leading)
      //
      }
      */
     }// .modifier(FitToWidth(fraction: 1))
     }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

     }.simultaneousGesture(LongPressGesture(minimumDuration: 1)
     .onEnded { _ in
     print("Loooong")

     }
     )
     */
}

struct BlindsButton: View {
    @ObservedObject var light: DomoticzLight

    var body: some View {
        Button(action: {
            // light.ToggleStatus()
        }) {
            HStack {
                Image("roller-shades")
                VStack {
                    Text(light.info.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // .modifier(FitToWidth(fraction: 1))
                    HStack {
                        // Text(light.info.switchType).frame(maxWidth: .infinity, alignment: .leading)

                        //
                    }
                }.modifier(FitToWidth(fraction: 1))
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        /*
         .simultaneousGesture(LongPressGesture(minimumDuration: 1)
         .onEnded { _ in
         print("Loooong")

         }
         )
         */
    }
}

struct LightsList: View {
    let lights: [DomoticzLight]

    var body: some View {
        ForEach(lights) { light in
            if light.info.switchTypeCode == 16 {
                BlindsButton(light: light)
            } else {
                LightButton(light: light)
            }
        }
    }
}
