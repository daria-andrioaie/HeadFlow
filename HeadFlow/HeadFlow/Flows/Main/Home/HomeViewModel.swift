//
//  HomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.03.2023.
//

import Foundation

extension Home {
    class ViewModel: ObservableObject {
        @Published var apiError: Error?
        @Published var isConfirmationMessagePresented: Bool = false
        var confirmationMessage: String = ""
        
        let authenticationService: AuthenticationServiceProtocol
        
        let onLogout: () -> Void
        
        init(authenticationService: AuthenticationServiceProtocol, onLogout: @escaping () -> Void) {
            self.authenticationService = authenticationService
            self.onLogout = onLogout
        }
        
        func logout() {
            Task(priority: .userInitiated) { @MainActor in
                await authenticationService.logout { [unowned self] result in
                    switch result {
                    case .success(let message):
                        self.isConfirmationMessagePresented = true
                        confirmationMessage = message
                        DispatchQueue.main.asyncAfter(seconds: 2) {
                            self.onLogout()
                        }
                    case .failure(let error):
                        apiError = Errors.CustomError(error.message)
                    }
                }
            }
        }
    }
}
