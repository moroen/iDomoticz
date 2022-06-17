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
                .frame(width: g.size.width * self.fraction)
        }
    }
}

struct ScaleToWidth: ViewModifier {
    var width: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.system(size: 1000))
            .minimumScaleFactor(0.005)
            .lineLimit(1)
            .frame(width: width)
    }
}

// View builders
@ViewBuilder
public func StateImageBuilder(state: String) -> some View {
    if state == "On" {
        Image(systemName: "lightbulb.fill").foregroundColor(Color(.systemYellow))
    } else {
        Image(systemName: "lightbulb")
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
