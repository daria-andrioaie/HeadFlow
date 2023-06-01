//
//  DependencyContainer.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation

class DependencyContainer {
    let authenticationService: AuthenticationServiceProtocol
    let notificationsService: NotificationsServiceProtocol
    let sessionService: SessionServiceProtocol
    let stretchingService: StretchingServiceProtocol
    let therapistService: TherapistServiceProtocol
    let patientService: PatientServiceProtocol
    let feedbackService: FeedbackServiceProtocol
    let motionManager: MotionManager
    
    let serverPath = Constants.SERVER_URL
    
    init() {
        notificationsService = NotificationsService()
        authenticationService = AuthenticationService(path: serverPath, notificationsService: notificationsService)
        sessionService = SessionService(path: serverPath)
        stretchingService = StretchingService(path: serverPath)
        therapistService = TherapistService(path: serverPath)
        patientService = PatientService(path: serverPath)
        feedbackService = FeedbackService(path: serverPath)
        motionManager = MotionManager()
    }
}

class MockDependencyContainer: DependencyContainer {
    override init() {
    }
}
