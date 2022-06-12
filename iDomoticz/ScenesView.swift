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
    
    private var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)
    
    private var scenes: [DomoticzScene]
    
    public init(scenes: [DomoticzScene]) {
        self.scenes = scenes
    }
    
    
    var body: some View {
        
#if os(tvOS)
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ScenesList(scenes: scenes)
            }
        }
#else
            List {
                ScenesList(scenes: scenes)
            }
#endif
        
      
    }
}

struct ScenesList: View {
    let scenes: [DomoticzScene]
    
    var body: some View {
        ForEach(scenes) { scene in
            SceneButton(scene: scene)
        }
    }
}

