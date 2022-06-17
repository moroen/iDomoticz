//
//  Settings.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 09/06/2022.
//

import Foundation
import SwiftUI

class MQTTConfig: ObservableObject, ConfigObject {
    @Published public var enabled: Bool = false
    @Published public var host: String = ""
    @Published public var topic: String = ""
    @Published public var port: Int = 0

    init() {
        update()
    }

    public func saveConfig() {
        UserDefaults.standard.set(enabled, forKey: "mqtt_enable")
        UserDefaults.standard.set(host, forKey: "mqtt_server")
        UserDefaults.standard.set(port, forKey: "mqtt_port")
        UserDefaults.standard.set(topic, forKey: "mqtt_topic")
    }
    
    public func update() {
        enabled = UserDefaults.standard.bool(forKey: "mqtt_enable")
        host = UserDefaults.standard.string(forKey: "mqtt_server") ?? "localhost"
        topic = UserDefaults.standard.string(forKey: "mqtt_topic") ?? "domoticz/out"
        port = UserDefaults.standard.integer(forKey: "mqtt_port")
        if port == 0 { port = 1883 }
    }
}

class DomoticzConfig: ObservableObject, ConfigObject {
    @Published public var host: String = ""
    @Published public var port: Int = 0
    let proto = "http"

    init() {
        self.update()
    }
    
    public func update() {
        host = UserDefaults.standard.string(forKey: "server_host") ?? "127.0.0.1"
        port = UserDefaults.standard.integer(forKey: "server_port")
        port = port != 0 ? port : 8080
    }

    public func saveConfig() {
        UserDefaults.standard.set(host, forKey: "server_host")
        UserDefaults.standard.set(port, forKey: "server_port")
    }

    public var server: String {
        return "\(proto)://\(host):\(port)"
    }
}

protocol ConfigObject {
    func saveConfig()
    func update()
}

class Settings: ObservableObject {
    private var proto: String = "http"

    @Published public var mqttConfig = MQTTConfig()
    @Published public var domoticzConfig = DomoticzConfig()

    init() {}

    public func saveSettings() {
        mqttConfig.saveConfig()
        domoticzConfig.saveConfig()
    }
    
    public func update() {
        self.mqttConfig.update()
        self.domoticzConfig.update()
    }
    
}
