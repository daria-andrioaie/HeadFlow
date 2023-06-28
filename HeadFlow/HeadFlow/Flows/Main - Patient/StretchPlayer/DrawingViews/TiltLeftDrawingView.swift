//
//  TiltLeftDrawingView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 01.04.2023.
//

import SwiftUI
import CoreMotion


struct TiltLeftDrawingView: View {
    @Binding var exercise: StretchingExercise
    @ObservedObject var motionManager: MotionManager
    var isPaused: Bool
    
    @State private var line = Line(color: .decoGreen)
    @State private var currentPosition: CGFloat = 0
    @State private var maximumX: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            drawProgress(context: &context, size: size)
        }
        .onChange(of: motionManager.currentRoll) { newValue in
            if isPaused {
                return
            }
            guard let newValue else {
                return
            }
            updateStretchingProgress(for: newValue)
        }
    }
    
    private func drawProgress(context: inout GraphicsContext, size: CGSize) {
            var path = Path()
            
            path.addLines(line.points.map({ point in
                CGPoint(x: point.x * size.width, y: size.height / 2)
            }))

            var backgroundPath = Path()
            backgroundPath.move(to: .init(x: 0, y: size.height / 2))
            backgroundPath.addLine(to: .init(x: size.width, y: size.height / 2))

            context.stroke(backgroundPath, with: .color(line.color.opacity(0.5)), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round))
            
            context.fill(.init(roundedRect: .init(x: (1 - currentPosition) * size.width -  12, y: size.height / 2 - 12, width: 24, height: 24), cornerRadius: 15), with: .color(line.color))

            context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round))
    }
    
    private func updateStretchingProgress(for newRoll: Double) {
        var currentRoll = newRoll / Double(exercise.goalDegrees)
                            
        guard currentRoll >= -1 && currentRoll < 0 else {
            return
        }
                
        currentRoll = abs(currentRoll)
                
        currentPosition = currentRoll
                
        if currentRoll > maximumX {
            exercise.achievedRangeOfMotion = currentRoll
            maximumX = currentRoll
            line.points.append(.init(x: (1 - currentRoll), y: 0))
        }
    }
}

struct TiltLeftDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        TiltLeftDrawingView(exercise: .constant(.mock1), motionManager: MotionManager(), isPaused: false)
    }
}
