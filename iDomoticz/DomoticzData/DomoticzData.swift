//
//  DomoticzData.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 03/05/2022.
//

import Foundation
import SwiftUI

class Domoticz {
    static let controller = Domoticz()
    
    
    private var host: String
    
    private init() {
        let _host = UserDefaults.standard.string(forKey: "server_host")
        let _port = UserDefaults.standard.string(forKey: "server_port")
        self.host = "http://\(_host ?? "localhost"):\(_port ?? "8080")"
    }
    
    public func GetHost() -> String {
        return self.host
    }
    
  
    
}

class DomoticzData: ObservableObject {
    @Published var scenes = [DomoticzScene]()
    @Published var rooms = [DomoticzRoom]()
    @Published var lights = [DomoticzLight]()
    
    static let shared = DomoticzData()
 
    private init() {
        loadDataFromUrl()
    }
 
    private var proto: String = "http"
    
    public var host: String {
        get {
            return UserDefaults.standard.string(forKey: "server_host") ?? "127.0.0.1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "server_host")
        }
    }

    public var port: Int {
        get {
            let _port = UserDefaults.standard.integer(forKey: "server_port")
            return _port != 0 ? _port : 8080
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "server_port")
        }
    }
    
    private var server: String {
        get {
            return "\(proto)://\(host):\(port)"
        }
    }
    
    public func DoJsonCommand(cmd: String) {
        guard let url = URL(string: "\(server)/json.htm?\(cmd)")
        else {
            print("Unable to set URLs")
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                print(error)
                return
            }
        }.resume()
                      
    }
    
    func loadDataFromUrl() {
        print("Loading data from \(server)/")
                
        guard let scenesurl = URL(string: "\(server)/json.htm?type=scenes"),
              let roomsURL = URL(string: "\(server)/json.htm?type=plans&order=name&used=true"),
              let lightsURL = URL(string: "\(server)/json.htm?type=devices&filter=light&used=true")
                
        else {
            print("Unable to set URLs")
            return
        }
        
        URLSession.shared.dataTask(with: lightsURL) {data, response, error in
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
                allLights.result.forEach{ res in
                    let row = self.lights.firstIndex(where: {$0.info.idx == res.idx})
                    if row == nil {
                        self.lights.append(DomoticzLight(definition: res))
                    } else {
                        self.lights[row!] = DomoticzLight(definition: res)
                    }
                }
            }
            
        }.resume()
        
        URLSession.shared.dataTask(with: roomsURL) {data, response, error in
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
        
        URLSession.shared.dataTask(with: scenesurl) {data, response, error in
            if let error = error {
                print(error)
                return
            }
            /*
            guard let httpResponse = response as? HTTPURLResponse
            else {
                print("Unable to set response")
                return
            }
            */
            
            
            
            guard let data = data
            else {
                print("Unabe to let data")
                return
            }
            
            // print (String(data: data, encoding: .utf8)!)
            
            guard let allScenes = try? JSONDecoder().decode(DomoticzScenes.self, from: data)
            else {
                print("Scenes decoder failed")
                return
            }
            
            DispatchQueue.main.async {
                self.scenes = allScenes.result.filter {
                    $0.type == "Scene"
                }
            }
            
            
            
        }.resume()
        
    }
    
    
}
