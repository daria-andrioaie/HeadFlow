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
    
    let serverPath = Constants.SERVER_URL
    
    init() {
        notificationsService = NotificationsService()
        authenticationService = AuthenticationService(path: serverPath, notificationsService: notificationsService)
        sessionService = SessionService(path: serverPath)
    }
}

class MockDependencyContainer: DependencyContainer {
    override init() {
        //TODO: pass mock services in the init
        super.init()
    }
}
