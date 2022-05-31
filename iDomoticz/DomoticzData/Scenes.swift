//
//  Scenes.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 16/04/2022.
//

import Foundation

/*
 struct DomoticzScene:Codable {
 
 var name: String?
 var sceneid: String?
 
 private enum CodingKeys: String, CodingKey {
 case name
 case sceneid = "idx"
 }
 }
 
 struct DomoticzScenes: Codable {
 var DayLength: String?
 var Result: [DomoticzScene]
 
 private enum CodingKeys: String, CodingKey {
 case DayLength
 case Result = "result"
 }
 
 private enum CollectionCodingKeys: String, CodingKey {
 case Result = "result"
 }
 
 init(from decoder: Decoder) throws {
 let container = try decoder.container(keyedBy: CodingKeys.self)
 let collection = try container.nestedContainer(keyedBy: CollectionCodingKeys.self, forKey: .Result)
 Result = try collection.decode([DomoticzScene].self, forKey: .Result)
 }
 }
 */

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import SwiftUI

// MARK: - Welcome
struct DomoticzScenes: Codable {
    let status, title: String
    let result: [DomoticzScene]
    
    enum CodingKeys: String, CodingKey {
        case result
        case status
        case title
        
    }
}

// MARK: - Result
struct DomoticzScene: Codable, Identifiable {
    let resultDescription: String
    let favorite: Int
    let lastUpdate, name, offAction, onAction: String
    let protected: Bool
    let status, timers, type: String
    let usedByCamera: Bool
    let idx: String
    
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case resultDescription = "Description"
        case favorite = "Favorite"
        case lastUpdate = "LastUpdate"
        case name = "Name"
        case offAction = "OffAction"
        case onAction = "OnAction"
        case protected = "Protected"
        case status = "Status"
        case timers = "Timers"
        case type = "Type"
        case usedByCamera = "UsedByCamera"
        case idx
    }
}




struct SceneButton: View {
    @State private var maxWidth: CGFloat = .zero
    
    var scene: DomoticzScene
    
    var body: some View {
        
        Button(action: {
            activateScene(sceneid: scene.idx)
        }) {
            HStack {
                Image(systemName: "theatermasks")
                Text(scene.name)
            } .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
    
    private func rectReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { gp -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = max(binding.wrappedValue, gp.frame(in: .local).width)
            }
            return Color.clear
        }
    }
}


func activateScene(sceneid: String) {
    guard let url = URL(string: "http://zwave.local:8080/json.htm?type=command&param=switchscene&idx=\(sceneid)&switchcmd=On")
    else {
        return
    }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
        if let error = error {
            print(error)
            return
        }
        
    })
    task.resume()
}
