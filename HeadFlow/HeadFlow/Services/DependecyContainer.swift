//
//  DependecyContainer.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation

class DependecyContainer {
    //TODO: declare services
    let authenticationService: AuthenticationServiceProtocol
    
    init() {
        authenticationService = AuthenticationService()
    }
}

class MockDependencyContainer: DependecyContainer {
    override init() {
        //TODO: pass mock services in the init
        super.init()
    }
}
