//
//  SwipeGesture.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 06.05.2023.
//

import Foundation
import SwiftUI

struct SwipeGestureModifier: ViewModifier {
    @Binding var offset: CGSize
    let canSwipe: Bool
    let onGestureCompleted: () -> Void
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset.width)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        guard canSwipe else {
                            return
                        }
                        
                        guard gesture.translation.width < 0 else {
                            self.offset = .zero
                            return
                        }
                        self.offset = gesture.translation
                    }
                    .onEnded { _ in
                        guard canSwipe else {
                            return
                        }
                        
                        if self.offset.width < -200 {
                            self.offset.width = -400
                            onGestureCompleted()
                        } else if self.offset.width < -100 {
                            self.offset.width = -100
                        } else {
                            self.offset = .zero
                        }
                    }
            )
            .animation(.easeInOut, value: offset)
    }
}

extension View {
    func swipeLeftGesture(offset: Binding<CGSize>, canSwipe: Bool = true, onGestureCompleted: @escaping () -> Void) -> some View {
        modifier(SwipeGestureModifier(offset: offset, canSwipe: canSwipe, onGestureCompleted: onGestureCompleted))
    }
}
