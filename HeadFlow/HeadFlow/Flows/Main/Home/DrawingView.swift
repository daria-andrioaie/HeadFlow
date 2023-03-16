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
    var lineWidth: CGFloat = 5
}

struct DrawingView: View {
    @StateObject var motionManager: MotionManager = MotionManager()
    @State private var line = Line()
    
    var body: some View {
        Text(motionManager.text)
        Canvas { context, size in
            var path = Path()
            path.addLines(line.points)
            context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
        }
        .onChange(of: motionManager.motion) { newValue in
            if let roll = newValue?.attitude.roll, let pitch = newValue?.attitude.pitch {
                line.points.append(.init(x: motionManager.degrees(roll) * 2.5 + 150, y: motionManager.degrees(pitch) * 2.5 + 150))
            } else {
                print("no point detected")
            }
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
