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
        private var respondToInvitationTask: Task<Void, Never>?
        private var interruptCollaborationTask: Task<Void, Never>?

        init(patientService: PatientServiceProtocol, onBack: @escaping () -> Void) {
            self.patientService = patientService
            self.onBack = onBack
            
            getTherapist()
        }
        
        @MainActor
        func respondToInvitation(isAccepted: Bool) {
            guard let collaboration else {
                return
            }
            
            respondToInvitationTask?.cancel()
            isLoading = true

            respondToInvitationTask = Task(priority: .userInitiated, operation: {
                await patientService.respondToInvitation(collaboration: collaboration, isAccepted: isAccepted, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let collaboration):
                        switch collaboration.status {
                        case .active:
                            self?.presentSuccessAnimation = true
                            self?.collaboration = collaboration
                        case .declined:
                            self?.collaboration = nil
                            self?.failureMessage = "You declined the invitation."
                        default:
                            break
                        }
                        Session.shared.hasNotificationFromTherapist = false
                    case .failure(let apiError):
                        print(apiError.localizedDescription)
                    }
                    self?.isLoading = false
                })
            })
        }
        
        func interruptCollaboration() {
            isLoading = true
            interruptCollaborationTask?.cancel()
            
            interruptCollaborationTask = Task(priority: .userInitiated, operation: { @MainActor in
                await patientService.interruptCollaboration(onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let collaboration):
                        self?.collaboration = nil
                        self?.failureMessage = "You interrupted you collaboration with therapist \(collaboration.therapist.firstName) \(collaboration.therapist.lastName)."

                    case .failure(let apiError):
                        print(apiError.localizedDescription)
                    }
                    
                    self?.isLoading = false
                })
            })
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
