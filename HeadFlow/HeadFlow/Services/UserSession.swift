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
    
    @UserDefault(key: StorageKeys.currentUserID, defaultValue: nil)
    var currentUserID: String?
    
    @UserDefault(key: StorageKeys.notificationsEnabled, defaultValue: nil)
    var notificationsEnabled: Bool?
    
    static let shared: Session = Session()
    
    var isValid: Bool {
        return accessToken?.isEmpty == false
    }
    
    func saveCurrentUser(userId: String, token: String) {
        currentUserID = userId
        accessToken = token
    }
    
    func close(error: Error? = nil) {
        guard isValid else { return }
        
        removeSessionData()
    }
    
    func removeSessionData() {
        accessToken = nil
        currentUserID = nil
    }
}

fileprivate extension Session {
    struct StorageKeys {
        static let accessToken = "accessToken"
        static let currentUserID = "currentUserID"
        static let notificationsEnabled = "notificationsEnabled"
    }
}
