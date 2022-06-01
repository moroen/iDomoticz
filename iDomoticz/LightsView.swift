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
        self.lights = lights
        self.header = header()
    }
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    
    
    var body: some View {
        header.font(.largeTitle)
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                Group {
                    ForEach (lights) {light in
                        if (light.info.switchTypeCode==16) {
                            BlindsButton(light: light)
                        } else {
                            LightButton(light: light)
                        }
                    }
                }
                
            }
            
        }
    }
}

