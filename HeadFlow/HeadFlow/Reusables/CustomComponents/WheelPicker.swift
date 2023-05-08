//
//  WheelPicker.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 06.05.2023.
//

import SwiftUI

struct PickerItem: Equatable {
    let id = UUID()
    let value: Int
}

enum SwipeDirection {
    case left, right
}

struct WheelPicker: View {
    @Binding var chosenIndex: Int
    
    @State private var rotationDegree: Double
    @State private var radius: Double
    @State private var swipeDirection: SwipeDirection
    
    let items: [PickerItem]
    let circleSize: Double
    
    init(chosenIndex: Binding<Int>, items: [PickerItem], circleSize: Double) {
        self.rotationDegree = -90.0 - Double(chosenIndex.wrappedValue) * Double(360 / items.count)
        self.radius = 150
        self.swipeDirection = .left
        self._chosenIndex = chosenIndex
        self.items = items
        self.circleSize = circleSize
    }
    
    var body: some View {
        ZStack {
            let anglePerItem = Double.pi * 2.0 / Double(items.count)
            let drag = DragGesture()
                .onEnded { value in
                    if value.location.x < value.startLocation.x - 10 {
                        swipeDirection = .left
                    } else if value.location.x > value.startLocation.x + 10 {
                        swipeDirection = .right
                    }
                    
                    moveWheel()
                }
            
            ZStack {
                Circle().fill(EllipticalGradient(colors: [.danubeBlue.opacity(0.5), .white]))
                ForEach(0 ..< items.count) { index in
                    let angle = Double(index) * anglePerItem
                    let xOffset = CGFloat(radius * cos(angle))
                    let yOffset = CGFloat(radius * sin(angle))
                    
                    Text("\(items[index].value)")
                        .rotationEffect(Angle(degrees: -rotationDegree))
                        .offset(x: xOffset, y: yOffset)
                        .foregroundColor(.oceanBlue.opacity(chosenIndex == index ? 1 : 0.6))
                        .font(.Main.semibold(size: chosenIndex == index ? 20 : 10))
                }
            }
            .rotationEffect(Angle(degrees: rotationDegree))
            .gesture(drag)
            .onAppear {
                radius = circleSize / 2 - 15
            }
        }
        .frame(width: circleSize, height: circleSize)
    }
    
    func moveWheel() {
        withAnimation(.spring(response: 0.7)) {
            switch swipeDirection {
            case .left:
                rotationDegree -= Double(360 / items.count)
                chosenIndex = chosenIndex == items.count - 1 ? 0 : chosenIndex + 1
            case .right:
                rotationDegree += Double(360 / items.count)
                chosenIndex = chosenIndex == 0 ? items.count - 1 : chosenIndex - 1
            }
        }
    }
}


#if DEBUG
struct WheelPicker_Previews: PreviewProvider {
    struct StatefulPicker: View {
        @State private var degree = -90.0
        @State private var index = 0
        let items: [PickerItem] = (0...50).map { PickerItem(value: $0)}
        
        var body: some View {
            ZStack(alignment: .bottom) {
                WheelPicker(chosenIndex: $index, items: items, circleSize: 400)
                    .frame(height: 150, alignment: .top)
                    .clipped()
                Text("duration")
                    .font(.Main.medium(size: 20))
                    .padding(10)
            }
        }
    }
    
    static var previews: some View {
        StatefulPicker()
    }
}
#endif
