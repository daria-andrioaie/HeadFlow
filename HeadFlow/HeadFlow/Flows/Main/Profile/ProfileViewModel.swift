//
//  File.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation

extension Profile {
    class ViewModel: ObservableObject {
        @Published var apiError: Error?
        @Published var isConfirmationMessagePresented: Bool = false
        var confirmationMessage: String = ""

        let authenticationService: AuthenticationServiceProtocol
        let navigationAction: (ProfileNavigationType) -> Void


        init( authenticationService: AuthenticationServiceProtocol, navigationAction: @escaping (ProfileNavigationType) -> Void) {
            self.authenticationService = authenticationService
            self.navigationAction = navigationAction
        }
        
        func logout() {
            Task(priority: .userInitiated) { @MainActor in
                await authenticationService.logout { [unowned self] result in
                    switch result {
                    case .success(let message):
                        self.isConfirmationMessagePresented = true
                        confirmationMessage = message
                        DispatchQueue.main.asyncAfter(seconds: 2) {
                            self.navigationAction(.logout)
                        }
                    case .failure(let error):
                        apiError = Errors.CustomError(error.message)
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
