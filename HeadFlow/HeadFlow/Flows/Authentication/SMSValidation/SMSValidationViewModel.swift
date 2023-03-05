//
//  SMSValidationViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import Foundation

extension SMSValidation {
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var timeRemaining = 30
        @Published var inputCode: String = "" {
            didSet {
                if inputCode.count == 4 {
                    validateSMS()
                }
            }
        }
        @Published var apiError: Error?
        var resendConfirmationMessage: String = ""
        @Published var isResendConfirmationPresented: Bool = false

        let phoneNumber: String
        let authenticationService: AuthenticationServiceProtocol
        var navigationAction: ((SMSValidationNavigationType) -> Void)
        init(phoneNumber: String,
             authenticationService: AuthenticationServiceProtocol,
             navigationAction: @escaping (SMSValidationNavigationType) -> Void) {
            self.phoneNumber = phoneNumber
            self.authenticationService = authenticationService
            self.navigationAction = navigationAction
        }
        
        func validateSMS() {
            Task(priority: .userInitiated) { @MainActor in
                isLoading = true
                await authenticationService.verifyOTP(inputCode, for: phoneNumber, onRequestCompleted: { [unowned self] result in
                    switch result {
                    case .success(_):
                        // save token to session
                        self.navigationAction(.onSMSValidated)
                    case .failure(let error):
                        apiError = Errors.CustomError(error.message)
                        isLoading = false
                        inputCode = ""
                    }
                })
            }
        }
        
        func resendCode() {
            Task(priority: .userInitiated) { @MainActor in
                await authenticationService.resendOTP(for: phoneNumber, onRequestCompleted: { [unowned self] result in
                    switch result {
                    case .success(let message):
                        // save token to session
                        resendConfirmationMessage = message
                        isResendConfirmationPresented = true
                        inputCode = ""
                    case .failure(let error):
                        apiError = Errors.CustomError(error.message)
                    }
                })
            }
        }
    }
    
    enum SMSValidationNavigationType {
        case goBack
        case onSMSValidated
    }
}
