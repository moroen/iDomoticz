//
//  RoomsView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 02/05/2022.
//

import SwiftUI

struct RoomsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var datas = DomoticzData()
    
    @State private var maxWidth: CGFloat = .zero
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
   
    var body: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 20) {
            ForEach(datas.rooms) { scene in
                Button(action: {}) {
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

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView()
    }
}
