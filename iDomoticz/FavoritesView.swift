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
        ScrollView {
            Text("Scenes").font(.title)
            ScenesView(scenes: domoticzData.scenes.filter {$0.favorite==1})
            Text("Lights").font(.title)
            LightsView(lights: domoticzData.lights.filter {$0.info.favorite==1}, header: { EmptyView() })
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
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView()
    }
}
*/
