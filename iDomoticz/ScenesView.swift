//
//  ContentView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 16/04/2022.
//

import SwiftUI
import CoreData



struct ScenesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State private var maxWidth: CGFloat = .zero
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    private var scenes: [DomoticzScene]
    
    public init(scenes: [DomoticzScene]) {
        self.scenes = scenes
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(scenes) { scene in
                    SceneButton(scene: scene)
                    
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
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ScenesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
}
*/
