//
//  TherapistCollaborationViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import Foundation

extension TherapistCollaboration {
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var failureMessage: String?
        @Published var collaboration: Collaboration? = nil
        
        let patientService: PatientServiceProtocol
        let onBack: () -> Void
        
        private var getTherapistTask: Task<Void, Never>?

        init(patientService: PatientServiceProtocol, onBack: @escaping () -> Void) {
            self.patientService = patientService
            self.onBack = onBack
            
            getTherapist()
        }
        
        private func getTherapist() {
            isLoading = true
            getTherapistTask?.cancel()
            
            getTherapistTask = Task(priority: .high, operation: { @MainActor in
                await patientService.getTherapistForCurrentPatient(onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let collaboration):
                        self?.collaboration = collaboration
                    case .failure(let apiError):
                        if apiError.code == 200 {
                            self?.failureMessage = "You do not collaborate with any therapist yet."
                        } else {
                            print(apiError.localizedDescription)
                        }
                    }
                    
                    self?.isLoading = false
                })
            })
        }
    
        deinit {
            getTherapistTask?.cancel()
        }
    }
}
