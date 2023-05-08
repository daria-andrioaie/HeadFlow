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
    private var patientMainCoordinator: PatientMainCoordinator?
    private var therapistMainCoordinator: TherapistMainCoordinator?
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    var rootViewController: UIViewController? {
        return navigationController
    }
    private let dependencyContainer = DependencyContainer()
    
    init(window: UIWindow) {
        self.window = window
        
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        
        //TODO: init dependency container
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        if let currentUser = Session.shared.currentUser {
            switch currentUser.type {
            case .patient:
                showPatientMainCoordinator()
            case .therapist:
                showTherapistMainCoordinator()
            }
        } else {
            showAuthenticationCoordinator()
        }
    }
    
    func showAuthenticationCoordinator() {
        let coordinator = AuthenticationCoordinator(window: window, dependencies: dependencyContainer, onEndAuthenticationFlow: { [weak self] userType in
            switch userType {
            case .patient:
                self?.showPatientMainCoordinator()
            case .therapist:
                self?.showTherapistMainCoordinator()
            }
        })
        self.authenticationCoordinator = coordinator
        coordinator.start(connectionOptions: nil)
    }
    
    func showPatientMainCoordinator() {
        let coordinator = PatientMainCoordinator(window: window, dependencies: dependencyContainer, onLogout: { [weak self] in
            Session.shared.close()
            self?.showAuthenticationCoordinator()
        })
        self.patientMainCoordinator = coordinator
        coordinator.start(connectionOptions: nil)
    }
    
    func showTherapistMainCoordinator() {
        let coordinator = TherapistMainCoordinator(window: window, dependencies: dependencyContainer, onLogout: { [weak self] in
            Session.shared.close()
            self?.showAuthenticationCoordinator()
        })
        self.therapistMainCoordinator = coordinator
        coordinator.start(connectionOptions: nil)
    }
}
