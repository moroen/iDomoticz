//
//  Settings.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 09/06/2022.
//

import Foundation
import SwiftUI

class MQTTConfig:ObservableObject, ConfigObject {
    @Published public var enabled: Bool
    @Published public var host: String
    @Published public var port: Int

    init() {
        self.enabled = UserDefaults.standard.bool(forKey: "mqtt_enable")
        self.host = UserDefaults.standard.string(forKey: "mqtt_server") ?? "localhost"
        self.port = UserDefaults.standard.integer(forKey: "mqtt_port")
        if self.port == 0 { self.port = 1883}
    }
    
    public func saveConfig () -> Void {
        UserDefaults.standard.set(self.enabled, forKey: "mqtt_enable")
        UserDefaults.standard.set(self.host, forKey: "mqtt_server")
        UserDefaults.standard.set(self.port, forKey: "mqtt_port")
    }
}

class DomoticzConfig: ObservableObject, ConfigObject {
    @Published public var host: String
    @Published public var port: Int
    let proto = "http"
    
    init () {
        self.host = UserDefaults.standard.string(forKey: "server_host") ?? "127.0.0.1"
        self.port = UserDefaults.standard.integer(forKey: "server_port")
        self.port = port != 0 ? port : 8080
    }
    
    public func saveConfig() {
        UserDefaults.standard.set(self.host, forKey: "server_host")
        UserDefaults.standard.set(self.port, forKey: "server_port")
    }
    
    public var server: String {
        get {
            return "\(proto)://\(host):\(port)"
        }
    }
}

protocol ConfigObject {
    func saveConfig()
}

class Settings: ObservableObject {
    private var proto: String = "http"

    @Published public var mqttConfig = MQTTConfig()
    @Published public var domoticzConfig = DomoticzConfig()
    
    init() {
    
    }
    
    public func saveSettings() {
        self.mqttConfig.saveConfig()
        self.domoticzConfig.saveConfig()
    }
}
