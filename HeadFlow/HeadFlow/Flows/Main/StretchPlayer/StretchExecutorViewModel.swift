//
//  StretchExecutorViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation
import UIKit
import SwiftUI

extension StretchExecutor {
    class ViewModel: ObservableObject {
        @Published var timeRemaining: Int
        @Published var isTimerRunning: Bool = true
        
        var navigationAction: ((NavigationType) -> Void)?
        var currentStretchingExecise: StretchingExercise {
            didSet {
                timeRemaining = currentStretchingExecise.duration
                timer = timer.upstream.autoconnect()
            }
        }
        
        var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        init(stretchingExecise: StretchingExercise) {
            currentStretchingExecise = stretchingExecise
            timeRemaining = currentStretchingExecise.duration
        }
        
        func openSettings() {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.tryOpen(url: settingsUrl)
        }
        
        func toggleTimer() {
            isTimerRunning.toggle()
            if isTimerRunning {
                timer = timer.upstream.autoconnect()
            } else {
                timer.upstream.connect().cancel()
            }
        }
    }
    
    enum NavigationType {
        case cancelStretching
        case nextExercise
    }
}
