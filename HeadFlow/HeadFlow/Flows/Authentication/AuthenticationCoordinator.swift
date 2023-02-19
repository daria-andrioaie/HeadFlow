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
            self?.showLogin()
        })
        navigationController.pushHostingController(rootView: Onboarding.ContentView(viewModel: onboardingVM))
    }
    
    func showLogin(animated: Bool = true) {
        let loginVM = Login.ViewModel(onBack: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }, onNext: { [weak self] in
            // show code confirmation screen
        })
        navigationController.pushHostingController(rootView: Login.ContentView(viewModel: loginVM), animated: animated)
    }
    
    func showRegister(animated: Bool = true) {
        let registerVM = Register.ViewModel { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushHostingController(rootView: Register.ContentView(viewModel: registerVM), animated: animated)
    }
}
