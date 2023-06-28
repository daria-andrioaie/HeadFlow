//
//  HomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.03.2023.
//

import Foundation
import Combine

extension PatientHome {
    class ViewModel: ObservableObject {
        @Published var hasNotificationFromTherapist: Bool = false

        let navigationAction: (PatientHome.NavigationType) -> Void
        let patientService: PatientServiceProtocol
        let hasNotificationFromTherapistSubject: CurrentValueSubject<Bool, Never>
        var cancellables: [AnyCancellable] = []
        
        private var getNotificationFromTherapistTask: Task<Void, Never>?
        
        init(patientService: PatientServiceProtocol,
             hasNotificationFromTherapistSubject: CurrentValueSubject<Bool, Never>,
             navigationAction: @escaping (PatientHome.NavigationType) -> Void) {
            self.patientService = patientService
            self.hasNotificationFromTherapistSubject = hasNotificationFromTherapistSubject
            self.navigationAction = navigationAction
            
            configureCancellables()
            getNotificationFromTherapist()
        }
        
        private func configureCancellables() {
            hasNotificationFromTherapistSubject
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.hasNotificationFromTherapist = value
                }
                .store(in: &cancellables)
        }
        
        private func getNotificationFromTherapist() {
            getNotificationFromTherapistTask?.cancel()
            
            getNotificationFromTherapistTask = Task(priority: .high, operation: { @MainActor in
                await patientService.getCollaborationOfCurrentPatient(onRequestCompleted: { [weak self] result in
                    switch result {
                    case .success(let collaboration):
                        if collaboration.status == .pending {
                            self?.hasNotificationFromTherapistSubject.send(true)
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
