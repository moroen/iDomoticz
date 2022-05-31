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
    
    @State private var buttonMaxWidth: CGFloat?
    
    
    
    // private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)
    
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
            let val = gp.frame(in: .local).width
            print(val, binding.wrappedValue)
            DispatchQueue.main.async {
                binding.wrappedValue = max(binding.wrappedValue, val)
            }
            
            return Color.clear
        }
    }
    
}

private extension ScenesView {
    struct HeightPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0
        
        static func reduce(
            value: inout CGFloat,
            nextValue: () -> CGFloat
        ) {
            value = max(value, nextValue())
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
