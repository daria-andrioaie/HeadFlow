//
//  DrawingView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 15.03.2023.
//

import SwiftUI

struct Line {
    var points: [CGPoint] = [.zero]
    var color: Color = .red
    var lineWidth: CGFloat = 10
}

struct DrawingView: View {
    @Binding var exercise: StretchingExercise
    @StateObject var motionManager: MotionManager = MotionManager()
    @State private var line = Line()
    @State private var currentPosition: CGFloat = 0
    
    @State private var maximumX: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            var path = Path()
            path.addLines(line.points.map({ point in
                CGPoint(x: point.x * size.width, y: size.height / 2)
            }))

            var backgroundPath = Path()
            backgroundPath.move(to: .init(x: 0, y: size.height / 2))
            backgroundPath.addLine(to: .init(x: size.width, y: size.height / 2))
            context.stroke(backgroundPath, with: .color(.red.opacity(0.5)), lineWidth: 10)
            
            context.fill(.init(roundedRect: .init(x: currentPosition * size.width, y: size.height / 2 - 12, width: 24, height: 24), cornerRadius: 15), with: .color(.red))

            context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
        }
        .onChange(of: motionManager.motion) { newValue in
            if let roll = newValue?.attitude.roll {
                let currentRoll = motionManager.degrees(roll) / Double(exercise.type.totalRangeOfMotion)
                
                guard currentRoll > 0 else {
                    return
                }
                
                currentPosition = currentRoll
                
                if currentRoll > maximumX {
                    exercise.achievedRangeOfMotion = currentRoll
                    maximumX = currentRoll
                    line.points.append(.init(x: currentRoll, y: 0))
                }
            } else {
                print("no point detected")
            }
        }
    }
}

#if DEBUG
struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(exercise: .constant(.mock1))
    }
}
#endif
