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
        private var phoneNumber: String = "" {
            didSet {
                if phoneNumber.count == 10 {
                    nextButtonIsEnabled = true
                } else if phoneNumber.count == 13 {
                    nextButtonIsEnabled = false
                }
            }
        }
        @Published var nextButtonIsEnabled: Bool = false
        @Published var invalidPhoneNumberError: Error?
        
        var phoneNumberBinding: Binding<String> {
            return Binding<String>.init {
                return self.formatPhoneNumber(self.phoneNumber)
            } set: { newValue in
                self.phoneNumber = newValue
            }
        }
        
        let screenType: ScreenType
        var navigationAction: (PhoneNumberInputNavigationType) -> Void
        let phoneNumberKit = PhoneNumberKit()
        
        init(screenType: ScreenType,
             navigationAction: @escaping (PhoneNumberInputNavigationType) -> Void) {
            self.screenType = screenType
            self.navigationAction = navigationAction
        }
        
        func onNext() {
//            guard isPhoneNumberValid(phoneNumber) else {
//                invalidPhoneNumberError = Errors.ValidationError.invalidPhoneNumber
//                return
//            }
            invalidPhoneNumberError = nil
            //TODO: send sms code
            
            navigationAction(.goToSMSValidation(phoneNumber))
        }
        
        func formatPhoneNumber( _ phoneNumber: String) -> String {
            let phoneNumberWithoutEmptySpaces = phoneNumber.replacingOccurrences(of: " ", with: "")

            if let validPhoneNumber = try? phoneNumberKit.parse(phoneNumberWithoutEmptySpaces, withRegion: "RO") {
                let formattedPhoneNumber = phoneNumberKit.format(validPhoneNumber, toType: .national)
                return formattedPhoneNumber
            }
            return phoneNumberWithoutEmptySpaces
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
