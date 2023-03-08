//
//  MainCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import Foundation
import UIKit
import SwiftUI
import UserNotifications

class MainCoordinator: Coordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.navigationBar.isHidden = true
        return navVC
    }()
    
    var rootViewController: UIViewController? {
        navigationController
    }
    
    let dependencies: DependencyContainer
    var onLogout: () -> Void

    
    init(window: UIWindow,
         dependencies: DependencyContainer, onLogout: @escaping () -> Void) {
        self.window = window
        self.dependencies = dependencies
        self.onLogout = onLogout
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        window.transitionViewController(navigationController)
        showHomeScreen()
    }
    
    func showHomeScreen() {
        let homeScreenVM = Home.ViewModel(authenticationService: dependencies.authenticationService, onLogout: onLogout)
        navigationController.pushHostingController(rootView: Home.ContentView(viewModel: homeScreenVM))
    }
}
