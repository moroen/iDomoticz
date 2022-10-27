//
//  Main.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 02/05/2022.
//

import SwiftUI

struct MainView: View {
    // @StateObject var domoticzData = Domoticz.controller.domoticzData

    @StateObject var domoticzData = DomoticzData.shared

    @State var selected = 0

    var body: some View {
        VStack {
            #if os(tvOS)
            ClockWidget()
            #endif
        TabView(selection: $selected) {
            FavoritesView(domoticzData: domoticzData)
                .tabItem {
                    Label("Favorites", systemImage: "list.dash")
                }.tag(0)
            RoomsView(domoticzData: domoticzData)
                .tabItem {
                    Label("Rooms", systemImage: "house")
                }.tag(1)

            LightsView(lights: domoticzData.lights, header: { EmptyView() })
                .tabItem {
                    Label("Lights", systemImage: "lightbulb.circle")
                }.tag(2)

            ScenesView(scenes: domoticzData.scenes)
                .tabItem {
                    Label("Scenes", systemImage: "theatermasks")
                }.tag(3)

            SensorsView(domoticzData: domoticzData)
                .tabItem {
                    Label("Sensors", image: "sensors")
                }.tag(4)
            
            CustomSettingsView(domoticzData: domoticzData)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }.tag(5)
        }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
