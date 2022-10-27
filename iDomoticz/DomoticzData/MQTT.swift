//
//  MQTT.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 09/06/2022.
//

import Foundation
import MQTTNIO

struct DomoticzPayload: Codable {
    // let battery: Int
    // let lastUpdate: String
    // let rssi: Int
    // let welcomeDescription, dtype, hwid, id: String
    let idx: Int
    // let name: String
    let nvalue: Int
    // let stype, svalue1, switchType: String
    // let unit: Int

    enum CodingKeys: String, CodingKey {
        // case battery = "Battery"
        // case lastUpdate = "LastUpdate"
        // case rssi = "RSSI"
        // case welcomeDescription = "description"
        // case dtype, hwid, id, idx, name, nvalue, stype, svalue1, switchType, unit
        case idx, nvalue
    }
}

extension DomoticzData {
    func connectMQTT() {
        self.mqttClient = MQTTClient(
            configuration: .init(
                target: .host(self.settings.mqttConfig.host, port: self.settings.mqttConfig.port),
                protocolVersion: .version3_1_1
            ),
            eventLoopGroupProvider: .createNew
        )

        self.mqttClient?.whenConnected { response in
            print("MQTT Connected, is session present: \(response.isSessionPresent)")
        }

        self.mqttClient?.whenDisconnected { _ in
            print("MQTT Disconnected")
        }

        self.mqttClient?.whenConnectionFailure {response in
            print("MQTT Connection to \(self.settings.mqttConfig.host):\(self.settings.mqttConfig.port) failed")
        }
        
        self.mqttClient?.subscribe(to: "domoticz/out")

        self.mqttClient?.whenMessage(forTopic: "domoticz/out") { message in
            // print("MQTT Received message")
            guard let payload = try? message.payload.decode(DomoticzPayload.self)
            else { print("Decode error")
                return
            }
            let status = payload.nvalue == 0 ? "Off" : "On"
            self.GetDevice(idx: String(payload.idx))?.updateStatus(status: status)
        }

        if self.settings.mqttConfig.enabled {
            self.mqttClient!.connect()
        } else {
            if self.mqttClient?.isConnected != nil {
                self.mqttClient?.disconnect()
            }
        }
    }
}

public extension MQTTPayload {
    internal enum DecodeErrors: Error {
        case unableToDecode
        case dataIsEmpty
    }

    var data: Data? {
        if let p = string {
            return p.data(using: .utf8)
        } else {
            return nil
        }
    }

    func decode<T>(_: T.Type) throws -> T where T: Decodable {
        guard let data = data
        else { throw DecodeErrors.dataIsEmpty }

        guard let ret = try? JSONDecoder().decode(T.self, from: data)
        else { throw DecodeErrors.unableToDecode }
        return ret
    }
}
