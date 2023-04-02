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
    private var stretchingCoordinator: StretchCoordinator?
    
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
        let homeScreenVM = HomeViewModel { [weak self]  navigationType in
            switch navigationType {
            case .startStretchCoordinator:
                self?.startStretchingCoordinator()
            case .goToProfile:
                self?.goToProfile()
            }
        }
        navigationController.pushHostingController(rootView: Home.ContentView(viewModel: homeScreenVM))
    }
    
    func startStretchingCoordinator() {
        let coordinator = StretchCoordinator(window: window, dependencies: dependencies) { [weak self] in
            self?.start(connectionOptions: nil)
        }
        self.stretchingCoordinator = coordinator
        coordinator.start(connectionOptions: nil)
    }
    
    func goToProfile() {
        let profileVM = Profile.ViewModel(authenticationService: dependencies.authenticationService, stretchingService: dependencies.stretchingService) { [weak self] navigationType in
            switch navigationType {
            case .goBack:
                self?.navigationController.popViewController(animated: true)
            case .goToHistory:
                self?.goToStretchingHistory()
            case .logout:
                self?.onLogout()
            }
        }
        navigationController.pushHostingController(rootView: Profile.ContentView(viewModel: profileVM), animated: true)
    }
    
    func goToStretchingHistory() {
        let stretchingHistoryVM = StretchingHistory.ViewModel(stretchingService: dependencies.stretchingService, onBack: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })

        navigationController.pushHostingController(rootView: StretchingHistory.ContentView(viewModel: stretchingHistoryVM), animated: true)
    }
}
