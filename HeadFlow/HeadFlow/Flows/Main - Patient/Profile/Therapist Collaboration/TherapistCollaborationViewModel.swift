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
        @Published var presentSuccessAnimation: Bool = false

        let patientService: PatientServiceProtocol
        let onBack: () -> Void
        
        private var getTherapistTask: Task<Void, Never>?
        private var acceptInvitationTask: Task<Void, Never>?

        init(patientService: PatientServiceProtocol, onBack: @escaping () -> Void) {
            self.patientService = patientService
            self.onBack = onBack
            
            getTherapist()
        }
        
        @MainActor
        func acceptInvitation() {
            guard let collaboration else {
                return
            }
            
            acceptInvitationTask?.cancel()
            isLoading = true

            acceptInvitationTask = Task(priority: .userInitiated, operation: {
                await patientService.acceptInvitation(collaboration: collaboration, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let collaboration):
                        self?.presentSuccessAnimation = true
                        self?.collaboration = collaboration
                        Session.shared.hasNotificationFromTherapist = false
                    case .failure(let apiError):
                        print(apiError.localizedDescription)
                    }
                    self?.isLoading = false
                })
            })

        }
        
        func declineInvitation() {
            Session.shared.hasNotificationFromTherapist = false
        }
        
        func interruptCollaboration() {
            
        }
        
        private func getTherapist() {
            isLoading = true
            getTherapistTask?.cancel()
            
            getTherapistTask = Task(priority: .userInitiated, operation: { @MainActor in
                await patientService.getCollaborationOfCurrentPatient(onRequestCompleted: { [weak self] result in
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
