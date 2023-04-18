//
//  DrawingView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 15.03.2023.
//

import SwiftUI

struct Line {
    var points: [CGPoint] = []
    var color: Color = .danubeBlue
    var lineWidth: CGFloat = 10
}

struct DrawingView: View {
    @Binding var exercise: StretchingExercise
    @ObservedObject var motionManager: MotionManager
    var isPaused: Bool
        
    var body: some View {
        switch exercise.type {
        case .tiltToRight:
            TiltRightDrawingView(exercise: $exercise, motionManager: motionManager, isPaused: isPaused)
        case .tiltToLeft:
            TiltLeftDrawingView(exercise: $exercise, motionManager: motionManager, isPaused: isPaused)
        case .rotateToRight:
            RotateRightDrawingView(exercise: $exercise, motionManager: motionManager, isPaused: isPaused)
        case .rotateToLeft:
            RotateLeftDrawingView(exercise: $exercise, motionManager: motionManager, isPaused: isPaused)
        case .tiltForward:
            TiltForwardDrawingView(exercise: $exercise, motionManager: motionManager, isPaused: isPaused)
        case .tiltBackwards:
            TiltBackwardsDrawingView(exercise: $exercise, motionManager: motionManager, isPaused: isPaused)

        case .fullRotationRight:
            Canvas { context, size in
                
            }
        case .fullRotationLeft:
            Canvas { context, size in
                
            }
        case .unknown:
            EmptyView()
        }
    }
}

#if DEBUG
struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(exercise: .constant(.mock1), motionManager: MotionManager(), isPaused: false)
    }
}
#endif
