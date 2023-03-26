//
//  SizeReader.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 26.03.2023.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeReaderModifier: ViewModifier {
    let onChange: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geoProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geoProxy.size)
                    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
            }
        )
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        modifier(SizeReaderModifier(onChange: onChange))
    }
}
