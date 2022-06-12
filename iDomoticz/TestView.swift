//
//  TestView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 30/05/2022.
//

import SwiftUI

struct TestView: View {
    @State private var priceHeight: CGFloat = 50
    
    private var items: [GridItem] {
        Array(
            repeating: GridItem(
                .adaptive(minimum: 150),
                spacing: 10
            ),
            count: 2
        )
    }
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: items, spacing: 10) {
                Group {
                    TileCellView(text: "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum ")
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: HeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .frame(height: priceHeight)
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(.blue)
                        )
                    TileCellView(text: "Lorem Ipsum Dolem")
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: HeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .frame(height: priceHeight)
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(.blue)
                        )
                    TileCellView(text: "Lorem ipsum dolor sit amet")
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: HeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .frame(height: priceHeight)
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(.blue)
                        )
                    TileCellView(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit,")
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: HeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .frame(height: priceHeight)
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(.blue)
                        )
                    TileCellView(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor")
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: HeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(.blue)
                        )
                }
            }
            
            .onPreferenceChange(HeightPreferenceKey.self) {
                priceHeight = $0
            }
            .padding(.horizontal)
        }
    }
}

struct TileCellView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
        }
    }
}

private extension TestView {
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
