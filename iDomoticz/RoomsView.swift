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
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    public init(domoticzData: DomoticzData) {
        self.domoticzData = domoticzData
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(domoticzData.rooms) { room in
                        NavigationLink(destination: LightsView(lights: domoticzData.lights.filter {$0.info.planID == room.idx}, header: { Text(room.name).font(.title)})) {
                            Text(room.name).frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
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

/*
 struct RoomsView_Previews: PreviewProvider {
 static var previews: some View {
 RoomsView()
 }
 }
 */
