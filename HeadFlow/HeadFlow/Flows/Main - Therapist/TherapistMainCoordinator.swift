//
//  TherapistMainCoordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 18.04.2023.
//

import Foundation
import UIKit

class TherapistMainCoordinator: Coordinator {
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
        let homeScreenVM = TherapistHome.ViewModel(therapistService: dependencies.therapistService) { [weak self]  navigationType in
            switch navigationType {
            case .goToProfile:
                self?.goToProfile()
            case .goToPatientCoaching(let patient):
                self?.goToPatientCoaching(patient: patient)
            }
        }
        navigationController.pushHostingController(rootView: TherapistHome.ContentView(viewModel: homeScreenVM))
    }
    
    func goToPatientCoaching(patient: User) {
        let patientCoachingVM = PatientCoaching.ViewModel(therapistService: dependencies.therapistService, patient: patient) { [weak self] navigationType in
            switch navigationType {
            case .goBack:
                self?.navigationController.popViewController(animated: true)
            case .goToHistory(let patient, let stretchingHistory):
                self?.goToStretchingHistory(patient: patient, stretchingHistory: stretchingHistory)
            }
        }
        navigationController.pushHostingController(rootView: PatientCoaching.ContentView(viewModel: patientCoachingVM), animated: true)
    }
    
    func goToStretchingHistory(patient: User, stretchingHistory: [StretchSummary.Model]) {
        let stretchingHistoryVM = StretchingHistory.ViewModel(patient: patient, stretchingHistory: stretchingHistory, onBack: { [weak self] in
            self?.navigationController.popViewController(animated: true)
        })

        navigationController.pushHostingController(rootView: StretchingHistory.ContentView(viewModel: stretchingHistoryVM), animated: true)
    }
    
    func goToProfile() {
        let profileVM = TherapistProfile.ViewModel(authenticationService: dependencies.authenticationService) { [weak self] navigationType in
            switch navigationType {
            case .goBack:
                self?.navigationController.popViewController(animated: true)
            case .logout:
                self?.onLogout()
            }
        }
        navigationController.pushHostingController(rootView: TherapistProfile.ContentView(viewModel: profileVM), animated: true)
    }
}
