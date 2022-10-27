//
//  FavoritesView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 04/05/2022.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var domoticzData: DomoticzData

    @State private var maxWidth: CGFloat = .zero

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    public init(domoticzData: DomoticzData) {
        self.domoticzData = domoticzData
    }

    var body: some View {
        #if os(tvOS)
            ScrollView {
                // Text("Temperatures").font(.title)
            
                Text("Scenes").font(.title)
                ScenesView(scenes: domoticzData.scenes.filter { $0.info.favorite == 1 })
                Text("Lights").font(.title)
                LightsView(lights: domoticzData.lights.filter { $0.favorite }, header: { EmptyView() })
            }
        #else
            List {
                Section(header: Text("Scenes")) {
                    ScenesList(scenes: domoticzData.scenes.filter { $0.info.favorite == 1 })
                }
                Section(header: Text("Lights")) {
                    LightsList(lights: domoticzData.lights.filter { $0.info.favorite == 1 })
                }
            }
        #endif
    }
}
