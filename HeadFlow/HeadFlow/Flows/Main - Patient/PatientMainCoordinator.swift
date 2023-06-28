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
import Combine

class PatientMainCoordinator: Coordinator {
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
    let hasNotificationFromTherapistSubject: CurrentValueSubject<Bool, Never>
    var onLogout: () -> Void
    
    init(window: UIWindow,
         dependencies: DependencyContainer, onLogout: @escaping () -> Void) {
        self.window = window
        self.dependencies = dependencies
        self.hasNotificationFromTherapistSubject = .init(false)
        self.onLogout = onLogout
    }
    
    func start(connectionOptions: UIScene.ConnectionOptions?) {
        window.transitionViewController(navigationController)
        showHomeScreen()
    }
    
    func showHomeScreen() {
        let homeScreenVM = PatientHome.ViewModel(patientService: dependencies.patientService,
        hasNotificationFromTherapistSubject: hasNotificationFromTherapistSubject) { [weak self]  navigationType in
            switch navigationType {
            case .startStretchCoordinator:
                self?.startStretchingCoordinator()
            case .goToProfile:
                self?.goToProfile()
            }
        }
        navigationController.pushHostingController(rootView: PatientHome.ContentView(viewModel: homeScreenVM))
    }
    
    func startStretchingCoordinator() {
        let coordinator = StretchCoordinator(window: window, dependencies: dependencies) { [weak self] in
            self?.start(connectionOptions: nil)
        }
        self.stretchingCoordinator = coordinator
        coordinator.start(connectionOptions: nil)
    }
    
    func goToProfile() {
        let profileVM = PatientProfile.ViewModel(
            authenticationService: dependencies.authenticationService,
            stretchingService: dependencies.stretchingService,
            hasNotificationFromTherapistSubject: hasNotificationFromTherapistSubject) { [weak self] navigationType in
            switch navigationType {
            case .goBack:
                self?.navigationController.popViewController(animated: true)
            case .goToHistory(let stretchingHistory):
                self?.goToStretchingHistory(stretchingHistory: stretchingHistory)
            case .goToTherapistCollaboration:
                self?.goToTherapistCollaboration()
            case .goToEditProfile:
                self?.goToEditProfile()
            case .logout:
                self?.onLogout()
            }
        }
        navigationController.pushHostingController(rootView: PatientProfile.ContentView(viewModel: profileVM), animated: true)
    }
    
    func goToStretchingHistory(stretchingHistory: [StretchSummary.Model]) {
        if let patient = Session.shared.currentUser {
            let stretchingHistoryVM = StretchingHistory.ViewModel(patient: patient,
                                                                  stretchingHistory: stretchingHistory,
                                                                  feedbackService: dependencies.feedbackService,
                                                                  onBack: { [weak self] in
                self?.navigationController.popViewController(animated: true)
            })

            navigationController.pushHostingController(rootView: StretchingHistory.ContentView(viewModel: stretchingHistoryVM), animated: true)
        }
    }
    
    func goToTherapistCollaboration() {
        let therapistCollaborationVM = TherapistCollaboration.ViewModel(
            patientService: dependencies.patientService,
            hasNotificationFromTherapistSubject: hasNotificationFromTherapistSubject,
            onBack: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })

        navigationController.pushHostingController(rootView: TherapistCollaboration.ContentView(viewModel: therapistCollaborationVM), animated: true)
    }
    
    func goToEditProfile() {
        let editProfileVM = EditProfile.ViewModel(authenticationService: dependencies.authenticationService, onBack: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })

        navigationController.pushHostingController(rootView: EditProfile.ContentView(viewModel: editProfileVM), animated: true)
    }

}
