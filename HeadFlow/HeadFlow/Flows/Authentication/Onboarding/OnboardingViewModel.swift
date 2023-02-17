//
//  OnboardingViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import Foundation

extension Onboaridng {
    class ViewModel: ObservableObject {
        var navigateToRegister: () -> Void
        var navigateToLogin: () -> Void

        init(navigateToRegister: @escaping () -> Void, navigateToLogin: @escaping () -> Void) {
            self.navigateToRegister = navigateToRegister
            self.navigateToLogin = navigateToLogin
        }
    }
}
