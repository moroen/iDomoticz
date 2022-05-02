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

    @ObservedObject var datas = DomoticzData()
    
    @State private var maxWidth: CGFloat = .zero
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
   
    var body: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 20) {
            ForEach(datas.scenes) { scene in
                Button(action: {activateScene(sceneid: scene.idx)}) {
                    Text(scene.name)
                        .background(rectReader($maxWidth))
                        .frame(minWidth: maxWidth)
                }.id(maxWidth)
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

private func activateScene(sceneid: String) {
    guard let url = URL(string: "http://zwave.local:8080/json.htm?type=command&param=switchscene&idx=\(sceneid)&switchcmd=On")
    else {
        return
    }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
        if let error = error {
            print(error)
            return
        }
        
    })
    task.resume()
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScenesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
