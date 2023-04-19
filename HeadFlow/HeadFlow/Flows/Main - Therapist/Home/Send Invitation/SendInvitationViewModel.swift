//
//  SendInvitationViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import Foundation

extension SendInvitation {
    class ViewModel: ObservableObject {
        @Published var patient: User? = nil
        @Published var isLoading: Bool = false
        @Published var failureMessage: String? = nil
        
        private var searchPatientTask: Task<Void, Error>?
        let therapistService: TherapistServiceProtocol
        
        init(therapistService: TherapistServiceProtocol) {
            self.therapistService = therapistService
        }
        
        func searchPatient(with emailAddress: String) {
            searchPatientTask?.cancel()
            isLoading = true
            
            searchPatientTask = Task(priority: .userInitiated) { @MainActor in
                await Task.sleep(seconds: 1)
                await therapistService.getPatientByEmailAddress(emailAddress: emailAddress, onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let patient):
                        DispatchQueue.main.async {
                            self?.patient = patient
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
        
        deinit {
            searchPatientTask?.cancel()
        }
    }
}
