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
                Text("getting your exercises")
                    .foregroundColor(.danubeBlue)
                    .font(.Main.regular(size: 20))
                ScalingDots()
            }
        }
        
        var countdownView: some View {
            Text("\(viewModel.timeRemaining)")
                .font(.Main.bold(size: 60))
                .foregroundColor(.danubeBlue)
                .scaleEffect(animationAmount)
                .opacity(animationAmount - 0.4)
                .animation(.easeIn(duration: 1).repeatForever(autoreverses: false), value: animationAmount)
                .onAppear {
                    animationAmount = 1.0
                }
            }
    }
}

#if DEBUG
struct CountdownScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownScreen.ContentView(viewModel: .init(stretchingService: MockStretchingService(), onCountdownFinished: { _ in }))
    }
}
#endif