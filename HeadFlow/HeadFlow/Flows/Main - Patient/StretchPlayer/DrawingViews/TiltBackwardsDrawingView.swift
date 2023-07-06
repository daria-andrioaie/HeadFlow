//
//  TiltBackwardsDrawingView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 03.04.2023.
//

import SwiftUI
import CoreMotion

struct TiltBackwardsDrawingView: View {
    @Binding var exercise: StretchingExercise
    @ObservedObject var motionManager: MotionManager
    var isPaused: Bool
    
    @State private var line = Line(color: .decoGreen)
    @State private var currentPosition: CGFloat = 0
    
    @State private var maximumY: CGFloat = 0
    @State private var minimumY: CGFloat = 1
    
    var body: some View {
        Canvas { context, size in
            drawProgress(context: &context, size: size)
        }
        .onChange(of: motionManager.currentPitch) { newValue in
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
                CGPoint(x: size.width / 2, y: point.y * size.height)
            }))

            var backgroundPath = Path()
        backgroundPath.move(to: .init(x: size.width / 2, y: 0))
        backgroundPath.addLine(to: .init(x: size.width / 2, y: size.height))

            context.stroke(backgroundPath, with: .color(line.color.opacity(0.5)), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round))
            
        context.fill(.init(roundedRect: .init(x: size.width / 2 - 12, y: (1 - currentPosition) * size.height -  12, width: 24, height: 24), cornerRadius: 15), with: .color(line.color))

            context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round))
    }
    
    private func updateStretchingProgress(for newPitch: Double) {
        var currentPitch = newPitch / Double(exercise.goalDegrees)
                            
        guard currentPitch > 0 && currentPitch <= 1 else {
            return
        }
                                
        currentPosition = currentPitch
        
        if currentPitch < minimumY {
            minimumY = currentPitch
            line.points.append(.init(x: 0, y: (1 - currentPitch)))
        }
                
        if currentPitch > maximumY {
            exercise.achievedRangeOfMotion = currentPitch
            maximumY = currentPitch
            line.points.append(.init(x: 0, y: (1 - currentPitch)))
        }
    }
}

struct TiltBackwardsDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(previewDevices) {
            TiltBackwardsDrawingView(
                exercise: .constant(.mock1),
                motionManager: MotionManager(),
                isPaused: false)
            .previewDevice($0)
            .previewDisplayName($0.rawValue)
        }
    }
}
