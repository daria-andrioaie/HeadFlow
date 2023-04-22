//
//  ProfileViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import Foundation

extension TherapistProfile {
    class ViewModel: ObservableObject {
        @Published var apiError: Error?
        @Published var isConfirmationMessagePresented: Bool = false
        var confirmationMessage: String = ""

        let authenticationService: AuthenticationServiceProtocol
        let navigationAction: (ProfileNavigationType) -> Void
        
        init(authenticationService: AuthenticationServiceProtocol, navigationAction: @escaping (ProfileNavigationType) -> Void) {
            self.authenticationService = authenticationService
            self.navigationAction = navigationAction
        }
        
        func logout() {
            Task(priority: .userInitiated) { @MainActor in
                await authenticationService.logout { [weak self] result in
                    switch result {
                    case .success(let message):
                        self?.isConfirmationMessagePresented = true
                        self?.confirmationMessage = message
                        DispatchQueue.main.asyncAfter(seconds: 2) {
                            self?.navigationAction(.logout)
                        }
                    case .failure(let error):
                        self?.apiError = Errors.CustomError(error.message)
                    }
                }
            }
        }
        
    }
    
    enum ProfileNavigationType {
        case goBack
        case logout
    }
}
