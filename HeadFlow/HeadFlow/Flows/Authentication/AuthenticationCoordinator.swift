//
//  AuthenticationCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import UIKit
import SwiftUI

class AuthenticationCoordinator: Coordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.navigationBar.isHidden = true
        return navVC
    }()
    var onEndAuthenticationFlow: () -> Void
    
    var rootViewController: UIViewController? {
        navigationController
    }
    
    init(window: UIWindow,
         dependencies: DependecyContainer,
         onEndAuthenticationFlow: @escaping () -> Void) {
        self.window = window
        self.onEndAuthenticationFlow = onEndAuthenticationFlow
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        window.transitionViewController(navigationController)
        showOnboarding()
    }
    
    func showOnboarding() {
        let onboardingVM = Onboarding.ViewModel(navigateToRegister: { [weak self] in
            self?.showRegister()
        }, navigateToLogin: { [weak self] in
            self?.showPhoneNumberInput(screenType: .login)
        })
        navigationController.pushHostingController(rootView: Onboarding.ContentView(viewModel: onboardingVM))
    }
    
    func showPhoneNumberInput(screenType: PhoneNumberInput.ScreenType, animated: Bool = true) {
        let phoneNumberInputVM = PhoneNumberInput.ViewModel(screenType: screenType, navigationAction: { [weak self] navigationType in
            switch navigationType {
            case .goBack:
                self?.navigationController.popViewController(animated: true)
            case .goToSMSValidation(let phoneNumber):
                self?.showSMSValidation(phoneNumber: phoneNumber)
            }
        })
        navigationController.pushHostingController(rootView: PhoneNumberInput.ContentView(viewModel: phoneNumberInputVM), animated: animated)
    }
    
    func showSMSValidation(phoneNumber: String, animated: Bool = true) {
        let smsValidationVM = SMSValidation.ViewModel(phoneNumber: phoneNumber, navigationAction: { [weak self] navigationType in
            switch navigationType {
            case .goBack:
                self?.navigationController.popViewController(animated: true)
            case .onSMSValidated:                
                self?.showAuthenticationCompleted()
            }
        })
        navigationController.pushHostingController(rootView: SMSValidation.ContentView(viewModel: smsValidationVM), animated: true)
    }
    
    func showRegister(animated: Bool = true) {
        let registerVM = Register.ViewModel { [weak self] navigationType in
            switch navigationType {
            case .goBack:
                self?.navigationController.popViewController(animated: true)
            case .next(let name):
                self?.showPhoneNumberInput(screenType: .signup(name))
            }
        }
        navigationController.pushHostingController(rootView: Register.ContentView(viewModel: registerVM), animated: animated)
    }
    
    func showAuthenticationCompleted(animated: Bool = false) {
        navigationController.pushHostingController(rootView: AuthenticationCompleteView(afterAppear: { [weak self] in
            self?.onEndAuthenticationFlow()
        }))
    }
}
