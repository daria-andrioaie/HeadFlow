//
//  CountdownScreenViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 10.05.2023.
//

import Foundation
import Combine

extension CountdownScreen {
    class ViewModel: ObservableObject {
        @Published var isPlannedSessionLoading: Bool = true
        @Published var apiError: Error? = nil
        @Published var timeRemaining = 5
        var plannedSession: [StretchingExercise] = []
        
        let stretchingService: StretchingServiceProtocol
        let motionManager: MotionManager
        let onCountdownFinished: ([StretchingExercise]) -> Void
        
        private let timer = Timer.publish(every: 1, on: .main, in: .common)
        private var cancellables = Set<AnyCancellable>()
        
        init(stretchingService: StretchingServiceProtocol,
             motionManager: MotionManager,
             onCountdownFinished: @escaping ([StretchingExercise]) -> Void) {
            self.stretchingService = stretchingService
            self.motionManager = motionManager
            self.onCountdownFinished = onCountdownFinished
            getPlannedSession()
        }
        
        private func getPlannedSession() {
            Task { @MainActor in
                await Task.sleep(seconds: 2)
                await stretchingService.getPlannedStretchingSessionForCurrentPatient(onRequestCompleted: { [weak self] result in
                    
                    switch result {
                    case .success(let plannedSession):
                        self?.plannedSession = plannedSession
                        self?.isPlannedSessionLoading = false
                        self?.motionManager.startComputingCoordinatesInStraightPosition()
                        self?.startCountdown()

                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.apiError = error
                    }
                })
            }
        }
        
        private func startCountdown() {
            timer.autoconnect()
                .sink { [weak self] _ in
                    if (self?.timeRemaining ?? 0) > 0 {
                        self?.timeRemaining -= 1
                    } else {
                        self?.timer.connect().cancel()
                        self?.motionManager.stopComputingCoordinatesInStraightPosition()
                        self?.onCountdownFinished(self?.plannedSession ?? [])
                    }
                }
                .store(in: &cancellables)
        }
    }
}
