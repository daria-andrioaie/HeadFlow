//
//  TherapistHomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import Foundation
import Combine

extension TherapistHome {
    class ViewModel: ObservableObject {
        @Published var selectedCollaborationStatus: CollaborationStatus = .active
        @Published var isLoading: Bool = true
        @Published var apiError: Error?
        @Published var collaborationsMap: [CollaborationStatus: [Collaboration]]
        
        let therapistService: TherapistServiceProtocol
        let navigationAction: (TherapistHome.NavigationType) -> Void
        
        private var getCollaborationsListTask: Task<Void, Error>?
        private let sendInvitation = PassthroughSubject<Void, Never>()
        private var cancellables = Array<AnyCancellable>()
        
        var collaborationsForSelectedStatus: [Collaboration] {
            collaborationsMap[selectedCollaborationStatus] ?? []
        }
        
        var noPatientsMessage: String {
            switch selectedCollaborationStatus {
            case .pending:
                return "There are no patients with pending invitations for the moment."
            case .active:
                return "There are no active patients for the moment."
            default:
                return ""
            }
        }
        
        var isDataSourceEmpty: Bool {
            for value in collaborationsMap.values {
                if !value.isEmpty {
                    return false
                }
            }
            return true
        }
        
        init(therapistService: TherapistServiceProtocol, navigationAction: @escaping (TherapistHome.NavigationType) -> Void) {
            self.therapistService = therapistService
            self.navigationAction = navigationAction
            
            collaborationsMap = [:]
        }
        
        func getCollaborationsList() {
            getCollaborationsListTask?.cancel()
            isLoading = true
            getCollaborationsListTask = Task(priority: .userInitiated) { @MainActor in
                await therapistService.getAllPatientsForCurrentTherapist { [weak self] result in
                    switch result {
                    case .success(let collaborationsResponse):
                        DispatchQueue.main.async {
                            self?.collaborationsMap.removeAll()
                            CollaborationStatus.allCases.forEach { collabStatus in
                                self?.collaborationsMap[collabStatus] = collaborationsResponse.filter { $0.status == collabStatus }
                            }
                            
                            self?.isLoading = false
                        }
                        
                    case .failure(let error):
                        print(error.message)
                        DispatchQueue.main.async {
                            self?.apiError = Errors.CustomError(error.message)
                            self?.isLoading = false
                        }
                    }
                }
            }
        }
        
        private func configureCancellables() {
            sendInvitation.sink { [weak self] error in
                self?.getCollaborationsList()
            }.store(in: &cancellables)
        }
                
        deinit {
            getCollaborationsListTask?.cancel()
        }
    }
}
    
extension TherapistHome {
    enum NavigationType {
        case goToProfile
        case goToPatientCoaching(User)
    }
}
