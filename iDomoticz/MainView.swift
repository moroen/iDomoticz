//
//  Main.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 02/05/2022.
//

import SwiftUI

class UserProgress: ObservableObject {
    @Published var score = 0
}

struct InnerView: View {
    @ObservedObject var progress: DomoticzData
    @State private var maxWidth: CGFloat = .zero
    
    
    var body: some View {
        
        Button("Increase Score") {
            print(progress.rooms)
        }
    }
}

struct MainView: View {
    // @StateObject var domoticzData = Domoticz.controller.domoticzData
    
    @StateObject var domoticzData = DomoticzData.shared
    
    @State var selected = 1
    
    var body: some View {

        TabView (selection: $selected) {
            
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
            
            SettingsView(domoticzData: domoticzData)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }.tag(4)
        }
        
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
