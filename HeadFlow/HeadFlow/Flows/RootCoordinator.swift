//
//  RootCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation
import UIKit

class RootCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let window: UIWindow?
    var rootViewController: UIViewController? {
        return navigationController
    }
    
    init(window: UIWindow) {
        self.window = window
        
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        
        //TODO: init dependency container
        
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions) {
        if Session.isValid {
            showMainCoordinator()
        } else {
            showAuthenticationCoordinator()
        }
    }
    
    func showAuthenticationCoordinator() {
        
    }
    
    func showMainCoordinator() {
        
    }
    
}
