//
//  FavoritesView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 04/05/2022.
//

import SwiftUI

struct SensorsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var domoticzData: DomoticzData

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    public init(domoticzData: DomoticzData) {
        self.domoticzData = domoticzData
    }

    var body: some View {
        #if os(tvOS)
            ScrollView {
                Text("Temperatures").font(.title)
                LazyVGrid(columns: gridItemLayout, spacing: 20) {

                    TempsList(temps: domoticzData.sensors)
                }
                
            }
        #else
            List {
                Section(header: Text("Temperatures")) {
                    TempsList(temps: domoticzData.sensors)
                }
            }
        #endif
    }
}


