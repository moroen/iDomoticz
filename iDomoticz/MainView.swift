//
//  Main.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 02/05/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView {
                    ScenesView()
                        .tabItem {
                            Label("Scenes", systemImage: "list.dash")
                        }

                    RoomsView()
                        .tabItem {
                            Label("Rooms", systemImage: "square.and.pencil")
                        }
                }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
