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

// MARK: - Welcome
struct DomoticzScenes: Codable {
    let actTime: Int
    let allowWidgetOrdering: Bool
    let astrTwilightEnd, astrTwilightStart, civTwilightEnd, civTwilightStart: String
    let dayLength, nautTwilightEnd, nautTwilightStart, serverTime: String
    let sunAtSouth, sunrise, sunset: String
    let result: [DomoticzScene]

    enum CodingKeys: String, CodingKey {
        case actTime = "ActTime"
        case allowWidgetOrdering = "AllowWidgetOrdering"
        case astrTwilightEnd = "AstrTwilightEnd"
        case astrTwilightStart = "AstrTwilightStart"
        case civTwilightEnd = "CivTwilightEnd"
        case civTwilightStart = "CivTwilightStart"
        case dayLength = "DayLength"
        case nautTwilightEnd = "NautTwilightEnd"
        case nautTwilightStart = "NautTwilightStart"
        case serverTime = "ServerTime"
        case sunAtSouth = "SunAtSouth"
        case sunrise = "Sunrise"
        case sunset = "Sunset"
        case result
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


 
