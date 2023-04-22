//
//  HomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.03.2023.
//

import Foundation

extension PatientHome {
    class ViewModel: ObservableObject {
        let navigationAction: (PatientHome.NavigationType) -> Void
        let patientService: PatientServiceProtocol
        
        var hasNotificationFromTherapist: Bool {
            Session.shared.hasNotificationFromTherapist
        }
        
        private var getNotificationFromTherapistTask: Task<Void, Never>?
        
        init(patientService: PatientServiceProtocol, navigationAction: @escaping (PatientHome.NavigationType) -> Void) {
            self.patientService = patientService
            self.navigationAction = navigationAction
            
            getNotificationFromTherapist()
        }
        
        private func getNotificationFromTherapist() {
            getNotificationFromTherapistTask?.cancel()
            
            getNotificationFromTherapistTask = Task(priority: .high, operation: { @MainActor in
                await patientService.getTherapistForCurrentPatient(onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let collaboration):
                        if collaboration.status == .pending {
                            Session.shared.hasNotificationFromTherapist = true
                            self?.objectWillChange.send()
                        }
                    case .failure(let apiError):
                        if apiError.code != 200 {
                            print(apiError.localizedDescription)
                        }
                    }
                })
            })
        }
        
        deinit {
            getNotificationFromTherapistTask?.cancel()
        }
    }
}
    
extension PatientHome {
    enum NavigationType {
        case startStretchCoordinator
        case goToProfile
    }
}
