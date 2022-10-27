//
//  Scenes.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 16/04/2022.
//

import Foundation
import SwiftUI

// MARK: - Welcome

struct DomoticzScenes: Codable {
    let status, title: String
    let result: [DomoticzSceneDefinition]

    enum CodingKeys: String, CodingKey {
        case result
        case status
        case title
    }
}

// MARK: - Result

struct DomoticzSceneDefinition: Codable, Identifiable {
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

class DomoticzScene: ObservableObject, Identifiable {
    let info: DomoticzSceneDefinition

    init(definition: DomoticzSceneDefinition) {
        self.info = definition
    }

    public func activate() {
        let cmd = "type=command&param=switchscene&idx=\(self.info.idx)&switchcmd=On"
        DomoticzData.shared.DoJsonCommand(cmd: cmd)
    }
}

extension DomoticzData {
    func GetScenes() {
        guard let URL = URL(string: "\(self.settings.domoticzConfig.server)/json.htm?type=scenes")
        else {
            print("Unable to set scenes URL")
            return
        }

        URLSession.shared.dataTask(with: URL) { data, _, error in
            if let error = error {
                print(error)
                return
            }

            guard let data = data
            else {
                print("Unabe to let scenes data")
                return
            }

            guard let all = try? JSONDecoder().decode(DomoticzScenes.self, from: data)
            else {
                print("Scenes decoder failed")
                return
            }

            DispatchQueue.main.async {
                all.result.forEach { res in
                    let row = self.scenes.firstIndex(where: { $0.info.idx == res.idx })
                    if row == nil {
                        self.scenes.append(DomoticzScene(definition: res))
                    } else {
                        self.scenes[row!] = DomoticzScene(definition: res)
                    }
                }
            }
        }.resume()
    }
}

struct SceneButton: View {
    @State private var maxWidth: CGFloat = .zero

    var scene: DomoticzScene

    var body: some View {
        Button(action: {
            scene.activate()
        }) {
            HStack {
                Image(systemName: "theatermasks")
                Text(scene.info.name)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

struct ScenesList: View {
    let scenes: [DomoticzScene]

    var body: some View {
        ForEach(scenes) { scene in
            SceneButton(scene: scene)
        }
    }
}
