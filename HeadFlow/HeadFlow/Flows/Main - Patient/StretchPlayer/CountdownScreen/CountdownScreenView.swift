//
//  CountdownScreenView.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 10.05.2023.
//

import Foundation
import SwiftUI

struct CountdownScreen {
    struct ContentView: View {
        @State private var animationAmount: CGFloat = 1.4
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                if viewModel.isPlannedSessionLoading {
                    loadingView
                } else {
                    countdownView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fillBackground()
        }
        
        var loadingView: some View {
            VStack(spacing: 30) {
                ScalingDots()
                    .frame(height: 70)

                Text("Getting your exercises")
                    .foregroundColor(.danubeBlue)
                    .font(.Main.regular(size: 20))
            }
        }
        
        var countdownView: some View {
            VStack(spacing: 30) {
                Text("\(viewModel.timeRemaining)")
                    .font(.Main.bold(size: 60))
                    .foregroundColor(.danubeBlue)
                    .scaleEffect(animationAmount)
                    .opacity(animationAmount - 0.4)
                    .animation(.easeIn(duration: 1).repeatForever(autoreverses: false), value: animationAmount)
                    .onAppear {
                        animationAmount = 1.0
                    }
                    .frame(height: 70)
                Text("Ready? Please adopt a straight position.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.danubeBlue)
                    .font(.Main.regular(size: 20))
            }
        }
    }
}

#if DEBUG
struct CountdownScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownScreen.ContentView(viewModel: .init(
            stretchingService: MockStretchingService(),
            motionManager: MotionManager(),
            onCountdownFinished: { _ in }))
    }
}
#endif
