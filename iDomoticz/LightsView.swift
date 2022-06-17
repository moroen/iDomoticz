//
//  DefaultView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 09/05/2022.
//

import SwiftUI

struct LightsView<Content: View>: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ViewBuilder var header: Content

    // @ObservedObject var lights: [DomoticzLight]

    let lights: [DomoticzLight]

    init(lights: [DomoticzLight], @ViewBuilder header: () -> Content) {
        self.lights = lights.sorted { $0.info.name < $1.info.name }
        self.header = header()
    }

    private var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        header.font(.largeTitle)
        #if os(tvOS)
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    LightsList(lights: lights)
                }
            }
        #else
            List {
                LightsList(lights: lights)
            }
        #endif
    }
}

struct LightsList: View {
    let lights: [DomoticzLight]

    var body: some View {
        ForEach(lights) { light in
            if light.info.switchTypeCode == 16 {
                BlindsButton(light: light)
            } else {
                LightButton(light: light)
            }
        }
    }
}
