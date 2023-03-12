//
//  LoginViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import SwiftUI
import PhoneNumberKit
import GoogleSignIn

extension PhoneNumberInput {
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
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
        weak var presentationController: UIViewController?
        var navigationAction: (PhoneNumberInputNavigationType) -> Void
        let phoneNumberKit = PhoneNumberKit()
        
        init(screenType: ScreenType,
             authenticationService: AuthenticationServiceProtocol,
             presentationController: UIViewController?,
             navigationAction: @escaping (PhoneNumberInputNavigationType) -> Void) {
            self.screenType = screenType
            self.authenticationService = authenticationService
            self.presentationController = presentationController
            self.navigationAction = navigationAction
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
        
        func signupWithGoogle() {
            guard let presentationController = presentationController else { return }
            let signInConfiguration = GIDConfiguration(clientID: Constants.GOOGLE_CLIENT_ID, serverClientID: Constants.GOOGLE_SERVER_CLIENT_ID)
            GIDSignIn.sharedInstance.configuration = signInConfiguration
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentationController) { [weak self] signInResult, error in
                guard error == nil else {
                    self?.apiError = Errors.CustomError(error.debugDescription)
                    return
                }
                guard let result = signInResult else {
                    self?.apiError = Errors.CustomError("There was an error while signing in with Google. Please try again later.")
                    return
                }
                
                guard let idToken = result.user.idToken?.tokenString else {
                    self?.apiError = Errors.CustomError("There was an error while signing in with Google. Please try again later.")
                    return
                }

                self?.sendSocialSignInToken(idToken)
            }
        }
        
        private func sendSocialSignInToken(_ token: String) {
            isLoading = true
            Task(priority: .userInitiated) {
                await authenticationService.socialSignIn(socialToken: token, onRequestCompleted: { [unowned self] result in
                    switch result {
                    case .success(_):
                        self.navigationAction(.socialLoginCompleted)
                    case .failure(let error):
                        apiError = Errors.CustomError(error.message)
                        isLoading = false
                    }
                })
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
    }
    
    enum PhoneNumberInputNavigationType {
        case goBack
        case goToSMSValidation(String)
        case socialLoginCompleted
    }
    
    enum ScreenType {
        case login
        case signup(String)
    }
}
