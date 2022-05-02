//
//  DomoticzData.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 03/05/2022.
//

import Foundation

class DomoticzData: ObservableObject {
    @Published var scenes = [DomoticzScene]()
    @Published var rooms = [DomoticzRoom]()
    
    init() {
        loadDataFromUrl()
    }
    
    func loadDataFromUrl() {
        guard let url = URL(string: "http://zwave.local:8080/json.htm?type=scenes"),
              let roomsURL = URL(string: "http://zwave.local:8080/json.htm?type=plans&order=name&used=true")
                
        else {
            print("Unable to set URLs")
            return
        }
        
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
        
        URLSession.shared.dataTask(with: url) {data, response, error in
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
