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
    
    var body: some View {
        
        TabView {
            FavoritesView(domoticzData: domoticzData)
                .tabItem {
                    Label("Favorites", systemImage: "list.dash")
                }
            LightsView(lights: domoticzData.lights)
                .tabItem {
                    Label("Lights", systemImage: "lightbulb.circle")
                }
            
            ScenesView(scenes: domoticzData.scenes)
                .tabItem {
                    Label("Scenes", systemImage: "theatermasks")
                }
            
            RoomsView(domoticzData: domoticzData)
                .tabItem {
                    Label("Rooms", systemImage: "house")
                }
            SettingsView(domoticzData: domoticzData)
                .tabItem {
                    Label("", systemImage: "gear")
                }
        }
        
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
