//
//  DomoticzData.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 03/05/2022.
//

import Foundation
import MQTTNIO
import SwiftUI


class DomoticzData: ObservableObject {
    @Published var scenes = [DomoticzScene]()
    @Published var rooms = [DomoticzRoom]()
    @Published var lights = [DomoticzLight]()
    @Published var sensors = [DomoticzSensor]()

    static let shared = DomoticzData()
    public var mqttClient: MQTTClient?

    let settings = Settings()

    private init() {
        self.update()
    }

    public func update() {
        self.settings.update()
        self.loadDataFromUrl()
        self.connectMQTT()
    }

    public func DoJsonCommand(cmd: String) {
        guard let url = URL(string: "\(self.settings.domoticzConfig.server)/json.htm?\(cmd)")
        else {
            print("Unable to set URLs")
            return
        }

        URLSession.shared.dataTask(with: url) { _, _, error in
            if let error = error {
                print(error)
                return
            }
        }.resume()
    }

    func loadDataFromUrl() {
        let server = self.settings.domoticzConfig.server
        print("Loading data from \(server)/")

      

        GetLights()
        GetTemps()
        GetScenes()
        GetRooms()
        

    }

    public func GetDevice(idx: String) -> DomoticzDevice? {
        let row = self.lights.firstIndex(where: { $0.info.idx == idx })
        if row == nil {
            return nil
        } else {
            return self.lights[row!]
        }
    }
}
