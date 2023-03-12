//
//  DependencyContainer.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation

class DependencyContainer {
    //TODO: declare services
    let authenticationService: AuthenticationServiceProtocol
    let notificationsService: NotificationsServiceProtocol
    
    init() {
        notificationsService = NotificationsService()
        authenticationService = AuthenticationService(path: .local, notificationsService: notificationsService)
    }
}

class MockDependencyContainer: DependencyContainer {
    override init() {
        //TODO: pass mock services in the init
        super.init()
    }
}
