//
//  MainCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.02.2023.
//

import Foundation
import UIKit
import SwiftUI

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
    
    let dependencies: DependecyContainer
    var onLogout: () -> Void

    
    init(window: UIWindow,
         dependencies: DependecyContainer, onLogout: @escaping () -> Void) {
        self.window = window
        self.dependencies = dependencies
        self.onLogout = onLogout
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        window.transitionViewController(navigationController)
        showHomescreen()
    }
    
    func showHomescreen() {
        let homescreenVM = Home.ViewModel(authenticationService: dependencies.authenticationService, onLogout: onLogout)
        navigationController.pushHostingController(rootView: Home.ContentView(viewModel: homescreenVM))
    }
}
