//
//  TherapistHomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import Foundation

extension TherapistHome {
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = true
        @Published var apiError: Error?
        var collaborationsList: [Collaboration] = []
        
        let therapistService: TherapistServiceProtocol
        let navigationAction: (TherapistHome.NavigationType) -> Void
        
        private var getCollaborationsListTask: Task<Void, Error>?
        
        init(therapistService: TherapistServiceProtocol, navigationAction: @escaping (TherapistHome.NavigationType) -> Void) {
            self.therapistService = therapistService
            self.navigationAction = navigationAction
            
            getCollaborationsList()
        }
        
        func getCollaborationsList() {
            getCollaborationsListTask?.cancel()
            getCollaborationsListTask = Task(priority: .userInitiated) { @MainActor in
                await therapistService.getAllPatientsForCurrentTherapist { [weak self] result in
                    switch result {
                    case .success(let collaborationsResponse):
                        DispatchQueue.main.async {
                            self?.collaborationsList = collaborationsResponse
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
        
        deinit {
            getCollaborationsListTask?.cancel()
        }
    }
}
    
extension TherapistHome {
    enum NavigationType {
        case goToProfile
    }
}
