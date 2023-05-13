//
//  PatientCoachingViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 30.04.2023.
//

import Foundation
import SwiftUI

extension PatientCoaching {
    class ViewModel: ObservableObject {
        @Published var plannedSession: [StretchingExercise] = []
        @Published var copyOfPlannedSession: [StretchingExercise] = []
        @Published var stretchingHistory: [StretchSummary.Model] = []
        @Published var isLoadingHistory: Bool = false
        @Published var isSavingPlan: Bool = false
        
        let therapistService: TherapistServiceProtocol
        let patient: User
        let navigationAction: (PatientCoachingNavigationType) -> Void

        private var getStretchingHistoryTask: Task<Void, Never>?
        private var getPlannedStretchingSessionTask: Task<Void, Never>?
        
        var patientName: String {
            patient.firstName + " " + patient.lastName
        }
        
        var lastRangeOfMotion: Double {
            stretchingHistory.last?.averageRangeOfMotion ?? 0
        }
        
        init(therapistService: TherapistServiceProtocol,
             patient: User,
             navigationAction: @escaping (PatientCoachingNavigationType) -> Void) {
            self.therapistService = therapistService
            self.patient = patient
            self.navigationAction = navigationAction
            
            getStretchingHistory()
            getPlannedStretchingSession()
        }
        
        func savePlannedSession() {
            isSavingPlan = true
            Task(priority: .userInitiated) { @MainActor in
                await therapistService.savePlanForPatient(patientId: patient.id, exerciseData: copyOfPlannedSession, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let plannedSession):
                        self?.plannedSession = plannedSession
                        self?.isSavingPlan = false
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
        
        private func getStretchingHistory() {
            isLoadingHistory = true
            
            getStretchingHistoryTask = Task(priority: .userInitiated) { @MainActor in
                await therapistService.getAllStretchingSessionsForPatient(patientId: patient.id, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let stretchingSessionsResponse):
                        self?.stretchingHistory = stretchingSessionsResponse
                        self?.isLoadingHistory = false
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
        
        private func getPlannedStretchingSession() {
            getPlannedStretchingSessionTask = Task(priority: .userInitiated) { @MainActor in
                await therapistService.getPlannedStretchingSessionForPatient(patientId: patient.id, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let plannedSession):
                        self?.plannedSession = plannedSession
                        self?.copyOfPlannedSession = plannedSession
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
        
        deinit {
            getStretchingHistoryTask?.cancel()
        }
    }
    
    enum PatientCoachingNavigationType {
        case goBack
        case goToHistory(User, [StretchSummary.Model])
    }
}
