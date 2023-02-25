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
    
    init(window: UIWindow,
         dependencies: DependecyContainer) {
        self.window = window
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        window.transitionViewController(navigationController)
        showHomescreen()
    }
    
    func showHomescreen() {
        navigationController.pushHostingController(rootView: Home.ContentView())
    }
}
