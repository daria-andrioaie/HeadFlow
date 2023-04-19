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
        var patientsList: [User] = []
        
        let therapistService: TherapistServiceProtocol
        let navigationAction: (TherapistHome.NavigationType) -> Void
        
        private var getPatientsListTask: Task<Void, Error>?
        
        init(therapistService: TherapistServiceProtocol, navigationAction: @escaping (TherapistHome.NavigationType) -> Void) {
            self.therapistService = therapistService
            self.navigationAction = navigationAction
            
            getPatientsList()
        }
        
        func getPatientsList() {
            getPatientsListTask?.cancel()
            getPatientsListTask = Task(priority: .userInitiated) { @MainActor in
                await therapistService.getAllPatientsForCurrentTherapist { [weak self] result in
                    switch result {
                    case .success(let patientsResponse):
                        DispatchQueue.main.async {
                            self?.patientsList = patientsResponse
                            self?.isLoading = false
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self?.apiError = Errors.CustomError(error.message)
                        }
                    }
                }
            }
        }
        
        deinit {
            getPatientsListTask?.cancel()
        }
    }
}
    
extension TherapistHome {
    enum NavigationType {
        case goToProfile
    }
}
