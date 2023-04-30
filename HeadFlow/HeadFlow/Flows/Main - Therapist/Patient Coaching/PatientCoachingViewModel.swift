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
        @Published var stretchingHistory: [StretchSummary.Model] = []
        @Published var isLoadingHistory: Bool = false
        
        let therapistService: TherapistServiceProtocol
        let patient: User
        let navigationAction: (PatientCoachingNavigationType) -> Void

        private var getStretchingHistoryTask: Task<Void, Never>?
        
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
        }
        
        func getStretchingHistory() {
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
        
        deinit {
            getStretchingHistoryTask?.cancel()
        }
    }
    
    enum PatientCoachingNavigationType {
        case goBack
        case goToHistory([StretchSummary.Model])
    }
}
