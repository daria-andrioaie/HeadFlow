//
//  TiltForwardDrawingView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 03.04.2023.
//

import SwiftUI
import CoreMotion

struct TiltForwardDrawingView: View {
    @Binding var exercise: StretchingExercise
    @ObservedObject var motionManager: MotionManager
    var isPaused: Bool
    
    @State private var line = Line(color: .decoGreen)
    @State private var currentPosition: CGFloat = 0
    @State private var maximumY: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            drawProgress(context: &context, size: size)
        }
        .onChange(of: motionManager.motion) { newValue in
            if isPaused {
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
            
        context.fill(.init(roundedRect: .init(x: size.width / 2 - 12, y: currentPosition * size.height -  12, width: 24, height: 24), cornerRadius: 15), with: .color(line.color))

            context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round))
    }
    
    private func updateStretchingProgress(for motion: CMDeviceMotion?) {
            if let pitch = motion?.attitude.pitch {
                var currentPitch = motionManager.degrees(pitch) / Double(exercise.type.maximumDegrees)
                
                print("Degrees: \(motionManager.degrees(pitch))\n\n\n")
            
                guard currentPitch >= -1 && currentPitch < 0 else {
                    return
                }
                
                currentPitch = abs(currentPitch)
                
                currentPosition = currentPitch
                
                if currentPitch > maximumY {
                    exercise.achievedRangeOfMotion = currentPitch
                    maximumY = currentPitch
                    line.points.append(.init(x: 0, y: currentPitch))
                }
            }
    }
}

struct TiltForwardDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        TiltForwardDrawingView(exercise: .constant(.mock1), motionManager: MotionManager(), isPaused: false)
    }
}
