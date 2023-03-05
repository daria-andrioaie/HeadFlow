//
//  LoginViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import SwiftUI
import PhoneNumberKit

extension PhoneNumberInput {
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = true
        @Published var nextButtonIsEnabled: Bool = false
        @Published var invalidPhoneNumberError: Error?
        @Published var phoneNumber: String = "" {
            didSet {
                if phoneNumber.count == 10 {
                    nextButtonIsEnabled = true
                } else {
                    nextButtonIsEnabled = false
                }
            }
        }
        @Published var apiError: Error?
        
        let authenticationService: AuthenticationServiceProtocol
        let screenType: ScreenType
        var navigationAction: (PhoneNumberInputNavigationType) -> Void
        let phoneNumberKit = PhoneNumberKit()
        
        init(screenType: ScreenType,
             authenticationService: AuthenticationServiceProtocol,
             navigationAction: @escaping (PhoneNumberInputNavigationType) -> Void) {
            self.screenType = screenType
            self.authenticationService = authenticationService
            self.navigationAction = navigationAction
        }
        
        func onNext() {
            isLoading = true
            guard validatePhoneNumber() else {
                isLoading = false
                return
            }
            //TODO: send sms code
            Task(priority: .userInitiated) {
                switch screenType {
                case .signup(let username):
                    await authenticationService.register(username: username, phoneNumber: phoneNumber, onRequestCompleted: { [unowned self] result in
                        switch result {
                        case .success(_):
                            self.navigationAction(.goToSMSValidation(self.phoneNumber))
                        case .failure(let error):
                            apiError = Errors.CustomError(error.message)
                            isLoading = false
                        }
                    })
                case .login:
                    await authenticationService.login(phoneNumber: phoneNumber, onRequestCompleted: { [unowned self] result in
                        switch result {
                        case .success(_):
                            self.navigationAction(.goToSMSValidation(self.phoneNumber))
                        case .failure(let error):
                            apiError = Errors.CustomError(error.message)
                            isLoading = false
                        }
                    })
                }
            }
        }
        
        private func validatePhoneNumber() -> Bool {
            guard isPhoneNumberValid(phoneNumber) else {
                invalidPhoneNumberError = Errors.ValidationError.invalidPhoneNumber
                return false
            }
            invalidPhoneNumberError = nil
            return true
        }
        
        private func isPhoneNumberValid(_ phoneNumber: String) -> Bool {
            return (try? phoneNumberKit.parse(phoneNumber, withRegion: "RO")) != nil
        }
        
        var greetingsLabel: String {
            switch screenType {
            case .login: return Texts.PhoneNumberInput.loginGreetingsLabel
            case .signup(let name): return Texts.PhoneNumberInput.signupGreetingsLabel(name: name)
            }
        }
        
        var infoLabel: String {
            switch screenType {
            case .login: return Texts.PhoneNumberInput.loginLabel
            case .signup: return Texts.PhoneNumberInput.signupLabel
            }
        }
        
        var alternativesLabel: String {
            switch screenType {
            case .login: return Texts.PhoneNumberInput.loginAlternativesLabel
            case .signup: return Texts.PhoneNumberInput.signupAlternativesLabel
            }
        }
    }
    
    enum PhoneNumberInputNavigationType {
        case goBack
        case goToSMSValidation(String)
    }
    
    enum ScreenType {
        case login
        case signup(String)
    }
}
