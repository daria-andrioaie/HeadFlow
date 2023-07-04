//
//  ToastDisplayView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.03.2023.
//

import SwiftUI

struct ToastDisplayView: View {
    
    @Binding var isPresented: Bool
    let message: String
    let backgroundColor: Color
    
    @State private var yTranslation: CGFloat = .zero
    @State private var isDragging = false
    
    var body: some View {
        if isPresented {
            Text(message)
                .font(.Main.semibold(size: 18))
                .foregroundColor(.white)
                .lineLimit(3)
                .lineSpacing(2)
                .minimumScaleFactor(0.9)
                .multilineTextAlignment(.leading)
                .padding(16)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(backgroundColor.cornerRadius(15))
                .offset(y: yTranslation)
                .padding(.horizontal, 24)
                .gesture(dragGesture())
                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top).combined(with: .opacity).animation(.linear(duration: 0.3))))
                .animation(.easeIn(duration: 0.4), value: yTranslation)
                .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 1))
                .onAppear {
                    automaticDismiss(after: 2)
                }
        }
    }
    
    private func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                let draggedHeight = value.translation.height
                if !isDragging {
                    isDragging = true
                }
                
                guard draggedHeight < .zero else {
                    if draggedHeight < 50 {
                        yTranslation = draggedHeight
                    }
                    return
                }
                
                if abs(draggedHeight) > 40 {
                    isPresented = false
                } else {
                    yTranslation = draggedHeight
                }
            }
            .onEnded { _ in
                yTranslation = .zero
                isDragging = false
                automaticDismiss(after: 1.3)
            }
    }
    
    private func automaticDismiss(after: TimeInterval) {
        DispatchQueue.main.asyncAfter(seconds: after) {
            if !isDragging {
                isPresented = false
            }
        }
    }
}

#if DEBUG
struct ToastDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            ToastDisplayView(isPresented: .constant(true),
                             message: "Hi! This is a toast display with a very very very very very very very very very very very very very very very very very very very very long message.",
                             backgroundColor: .decoGreen)
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
#endif
