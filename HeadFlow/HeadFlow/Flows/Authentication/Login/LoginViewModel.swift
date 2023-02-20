//
//  LoginViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import SwiftUI
import PhoneNumberKit

extension Login {
    class ViewModel: ObservableObject {
        private var phoneNumber: String = "" {
            willSet {
                if newValue.count == 10 {
                    nextButtonIsEnabled = true
                } else if phoneNumber.count == 10 && newValue.count == 9 {
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
        
        var onLoginNavigation: ((LoginNavigationType) -> Void)?
        let phoneNumberKit = PhoneNumberKit()
        
        init() { }
        
        func loginAction() {
            guard isPhoneNumberValid(phoneNumber) else {
                invalidPhoneNumberError = Errors.ValidationError.invalidPhoneNumber
                return
            }
            invalidPhoneNumberError = nil
            //TODO: send sms code
            
            onLoginNavigation?(.goToSMSValidation)
        }
        
        func formatPhoneNumber( _ phoneNumber: String) -> String {
            let phoneNumberWithoutEmptySpaces = phoneNumber.replacingOccurrences(of: " ", with: "")

            if let validPhoneNumber = try? phoneNumberKit.parse(phoneNumberWithoutEmptySpaces, withRegion: "RO") {
                let formattedPhoneNumber = phoneNumberKit.format(validPhoneNumber, toType: .international)
                return formattedPhoneNumber
            }
            return phoneNumberWithoutEmptySpaces
        }
        
        private func isPhoneNumberValid(_ phoneNumber: String) -> Bool {
            return (try? phoneNumberKit.parse(phoneNumber, withRegion: "RO")) != nil
        }
    }
    
    enum LoginNavigationType {
        case goBack
        case goToSMSValidation
    }
}
