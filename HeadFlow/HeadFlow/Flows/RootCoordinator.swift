//
//  RootCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation
import UIKit

class RootCoordinator: Coordinator {
    private var authenticationCoordinator: AuthenticationCoordinator?
    private var mainCoordinator: MainCoordinator?
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    var rootViewController: UIViewController? {
        return navigationController
    }
    private let dependecyContainer = DependecyContainer()
    
    init(window: UIWindow) {
        self.window = window
        
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        
        //TODO: init dependency container
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        if Session.isValid {
            showMainCoordinator()
        } else {
            showAuthenticationCoordinator()
        }
    }
    
    func showAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(window: window, dependencies: dependecyContainer) { [weak self] in
            self?.showMainCoordinator()
        }
        self.authenticationCoordinator = coordinator
        coordinator.start(connectionOptions: nil)
    }
    
    func showMainCoordinator() {
        let coordinator = MainCoordinator(window: window, dependencies: dependecyContainer)
        self.mainCoordinator = coordinator
        coordinator.start(connectionOptions: nil)
    }
    
}
