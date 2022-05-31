//
//  RoomsView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 02/05/2022.
//

import SwiftUI

struct RoomsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var domoticzData: DomoticzData
    
    @State private var maxWidth: CGFloat = .zero
    
    
    // private var gridItemLayout: [GridItem]
    
    public init(domoticzData: DomoticzData) {
        self.domoticzData = domoticzData
    }
    
#if os(tvOS)
#else
#endif
    
    var body: some View {
        NavigationView {
#if os(tvOS)
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    RoomsList(domoticzData: domoticzData)
                }
            }
#else
            List {
                RoomsList(domoticzData: domoticzData)
            }
#endif
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


struct RoomsList: View {
    @ObservedObject var domoticzData: DomoticzData
    
    var body: some View {
        ForEach(domoticzData.rooms) { room in
            NavigationLink(destination: LightsView(lights: domoticzData.lights.filter {$0.info.planID == room.idx}, header: { Text(room.name) })) {
                Text(room.name)
                    .frame(maxWidth: .infinity)
            }
    }
}
}

/*
 struct RoomsView_Previews: PreviewProvider {
 static var previews: some View {
 RoomsView()
 }
 }
 */
