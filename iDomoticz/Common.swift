//
//  Common.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 01/06/2022.
//

import SwiftUI

// View Modifiers
struct FitToWidth: ViewModifier {
    var fraction: CGFloat = 1.0
    func body(content: Content) -> some View {
        GeometryReader { g in
        content
            .font(.system(size: 1000))
            .minimumScaleFactor(0.005)
            .lineLimit(1)
            .frame(width: g.size.width*self.fraction)
        }
    }
}

// View builders
@ViewBuilder
public func StateImageBuilder(state: String) -> some View {
    
    if state=="On" {
        Image(systemName: "lightbulb.fill").foregroundColor(Color(.systemYellow))
    } else {
        Image(systemName: "lightbulb")
    }
}
