//
//  SendInvitationViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import Foundation
import Combine

extension SendInvitation {
    enum InvitationStatus {
        case sending, sent
    }
    
    class ViewModel: ObservableObject {
        @Published var patient: User? = nil
        @Published var isLoading: Bool = false
        @Published var invitationStatus: InvitationStatus? = nil
        @Published var failureMessage: String? = nil
        
        private var searchPatientTask: Task<Void, Error>?
        private var sendInvitationTask: Task<Void, Error>?

        let therapistService: TherapistServiceProtocol
        let invitationPublisher: PassthroughSubject<Void, Never>
        
        init(therapistService: TherapistServiceProtocol, invitationPublisher: PassthroughSubject<Void, Never>) {
            self.therapistService = therapistService
            self.invitationPublisher = invitationPublisher
        }
        
        func searchPatient(with emailAddress: String) {
            searchPatientTask?.cancel()
            
            isLoading = true
            
            searchPatientTask = Task(priority: .userInitiated) { @MainActor in
                await therapistService.getPatientByEmailAddress(emailAddress: emailAddress, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let patient):
                        DispatchQueue.main.async {
                            self?.patient = patient
                            self?.invitationStatus = nil
                        }
                    case .failure(let apiError):
                        if apiError.code == 200 {
                            DispatchQueue.main.async {
                                self?.failureMessage = apiError.message
                            }
                        } else {
                            print(apiError.localizedDescription)
                        }
                    }
                    DispatchQueue.main.async {
                        self?.isLoading = false
                    }
                })
            }
        }
        
        func sendInvitation() {
            guard let patient = patient else {
                return
            }
            sendInvitationTask?.cancel()
            invitationStatus = .sending
            
            sendInvitationTask = Task(priority: .userInitiated) { @MainActor in
                await Task.sleep(seconds: 1)
                await therapistService.sendInvitation(patientId: patient.id, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self?.invitationStatus = .sent
                            self?.invitationPublisher.send()
                        }
                    case .failure(let apiError):
                        print(apiError.localizedDescription)
                        DispatchQueue.main.async {
                            self?.invitationStatus = nil
                        }
                    }
                })
            }
        }
        
        deinit {
            searchPatientTask?.cancel()
            sendInvitationTask?.cancel()
        }
    }
}
