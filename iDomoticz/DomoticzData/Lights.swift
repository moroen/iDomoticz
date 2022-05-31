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
struct DomoticzLightDefinition: Codable, Identifiable {
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
        case level="Level"
        case status = "Status"
        case idx
    }
}

class DomoticzLight: ObservableObject, Identifiable {
    @Published var info: DomoticzLightDefinition
    
    var id = UUID()
    
    init(definition: DomoticzLightDefinition) {
        self.info = definition
        if self.info.switchTypeCode==7 && self.info.status != "Off"{
            self.info.status = self.info.level > 0 ? "On" : "Off"
        }
    }
    
    public func SetStatus(status: String) {
        self.info.status=status
        
        let cmd = "type=command&param=switchlight&idx=\(self.info.idx)&switchcmd=\(status)"
        print(cmd)
        DomoticzData.shared.DoJsonCommand(cmd: cmd)
    }
    
    public func ToggleStatus() {
        self.info.status = self.info.status == "On" ? "Off" : "On"
        self.SetStatus(status: self.info.status)
    }
    
}

struct LightButton: View {
    @ObservedObject var light: DomoticzLight
    
    var body: some View {
        
        Button(action: {
            light.ToggleStatus()            
        }) {
            HStack {
                StateImage(state: light.info.status )
                Text(light.info.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(FitToWidth(fraction: 1))
                    
                
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
        }.simultaneousGesture(LongPressGesture(minimumDuration: 1)
            .onEnded { _ in
                print("Loooong")
                
            }
        )
        
    }
    
    @ViewBuilder
    private func StateImage(state: String) -> some View {
        
        if state=="On" {
            Image(systemName: "lightbulb.fill").foregroundColor(Color(.systemYellow))
        } else {
            Image(systemName: "lightbulb")
        }
    }
}

struct FitToWidth: ViewModifier {
    var fraction: CGFloat = 1.0
    func body(content: Content) -> some View {
        GeometryReader { g in
        content
            .font(.system(size: 1000))
            .minimumScaleFactor(0.005)
            .lineLimit(1)
            .frame(width: g.size.width*self.fraction)
        }
    }
}
