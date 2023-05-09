//
//  ScalingDots.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 09.05.2023.
//

import Foundation
import SwiftUI

struct ScalingDots: View {
    @State private var shouldAnimate = false
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: shouldAnimate)
            Circle()
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3), value: shouldAnimate)
            Circle()
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6), value: shouldAnimate)
        }
        .foregroundColor(.danubeBlue)
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

struct ScalingDots_Previews: PreviewProvider {
    static var previews: some View {
        ScalingDots()
    }
}
