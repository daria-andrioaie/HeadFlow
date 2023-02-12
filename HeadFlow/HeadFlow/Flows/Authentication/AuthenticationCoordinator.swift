//
//  AuthenticationCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import UIKit

class AuthenticationCoordinator: Coordinator {
//    private weak var presentationController: UIViewController?
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
    
//    init(presentationController: UIViewController?,
//         dependencies: DependecyContainer,
//         onEndAuthenticationFlow: @escaping () -> Void) {
//        self.presentationController = presentationController
//        self.onEndAuthenticationFlow = onEndAuthenticationFlow
//
//        navigationController.navigationBar.isHidden = true
//        navigationController.modalPresentationStyle = .fullScreen
//    }
    
    init(window: UIWindow,
         dependencies: DependecyContainer,
         onEndAuthenticationFlow: @escaping () -> Void) {
        self.window = window
        self.onEndAuthenticationFlow = onEndAuthenticationFlow
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        showLogin()
    }
    
    func showLogin(animated: Bool = true) {
        let loginVC = Login.ViewController()
        navigationController.setViewControllers([loginVC], animated: animated)
        window.transitionViewController(navigationController)
    }
}
