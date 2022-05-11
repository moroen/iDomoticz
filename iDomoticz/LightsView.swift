//
//  DefaultView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 09/05/2022.
//

import SwiftUI

struct LightsView<Header>: View where Header: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var maxWidth: CGFloat = .zero
    
    // @ObservedObject var lights: [DomoticzLight]
    
    let lights: [DomoticzLight]
    let header: Header
    

    init(lights: [DomoticzLight], @ViewBuilder header: ()->Header) {
        self.lights = lights
        self.header = header()
    }

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    

    
    var body: some View {
        ScrollView {
            header
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach (lights) {light in
                    LightButton(light: light)
                    
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

extension LightsView where Header == EmptyView {
    init (lights: [DomoticzLight]) {
        self.init(lights: lights) {EmptyView()}
    }
}

/*
struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
*/
