//
//  UserSession.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation
import UIKit
import Combine
import UserNotifications

class Session {
    @UserDefault(key: StorageKeys.accessToken, defaultValue: nil)
    var accessToken: String?
    
    @UserDefault(key: StorageKeys.currentUser, defaultValue: nil)
    var currentUser: User?
    
    @UserDefault(key: StorageKeys.notificationsEnabled, defaultValue: nil)
    var notificationsEnabled: Bool?
    
    static let shared: Session = Session()
    
    var isValid: Bool {
        return accessToken?.isEmpty == false
    }
    
    func saveCurrentUser(user: User, token: String) {
        currentUser = user
        accessToken = token
    }
    
    func close(error: Error? = nil) {
        guard isValid else { return }
        
        removeSessionData()
    }
    
    func removeSessionData() {
        accessToken = nil
        currentUser = nil
    }
}

fileprivate extension Session {
    struct StorageKeys {
        static let accessToken = "accessToken"
        static let currentUser = "currentUser"
        static let notificationsEnabled = "notificationsEnabled"
    }
}
