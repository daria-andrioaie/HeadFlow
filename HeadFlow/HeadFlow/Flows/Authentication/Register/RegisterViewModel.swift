//
//  RegisterViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import Foundation
import SwiftUI

extension Register {
    class ViewModel: ObservableObject {
        @Published var firstNameInput: String = ""
        @Published var lastNameInput: String = ""
        @Published var emailInput: String = ""
        
        var userTypeBinding: Binding<Bool> {
            return Binding<Bool>.init {
                self.userType == .therapist
            } set: { newValue in
                self.userType = newValue ? .therapist : .patient
            }
        }
        
        @Published private var userType: UserType = .patient

        var nextButtonIsEnabled: Bool {
            !firstNameInput.isEmpty && !lastNameInput.isEmpty && !emailInput.isEmpty
        }
        
        var navigationAction: (RegisterNavigationType) -> Void
        
        init(navigationAction: @escaping (RegisterNavigationType) -> Void) {
            self.navigationAction = navigationAction
        }
        
        func onNext() {
            
            navigationAction(.next(RegistrationInfo(firstName: firstNameInput, lastName: lastNameInput, email: emailInput, userType: userType)))
        }
    }
    
    enum RegisterNavigationType {
        case goBack
        case next(RegistrationInfo)
    }
}
