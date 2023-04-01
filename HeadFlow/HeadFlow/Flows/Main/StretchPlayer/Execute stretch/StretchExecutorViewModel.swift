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
    enum TimerStateType {
        case running
        case paused
        case disabled
    }
    
    class ViewModel: ObservableObject {
        @Published var timeRemaining: Int
        @Published var timerState: TimerStateType = .running
        
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
            if timerState == .running {
                timerState = .paused
                timer.upstream.connect().cancel()

            } else if timerState == .paused {
                timerState = .running
                timer = timer.upstream.autoconnect()
            }
        }
        
        func disableTimer() {
            if timerState == .running {
                timer.upstream.connect().cancel()
            }
            timerState = .disabled
        }
        
        func enableTimer() {
            timerState = .paused
        }
    }
    
    enum NavigationType {
        case cancelStretching
        case nextExercise
    }
}
