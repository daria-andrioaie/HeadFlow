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
    static var accessToken: String?
    
    @UserDefault(key: StorageKeys.currentUserID, defaultValue: nil)
    static var currentUserID: String?
    
    static var isValid: Bool {
        return accessToken?.isEmpty == false
    }
}

fileprivate extension Session {
    struct StorageKeys {
        static let accessToken = "accessToken"
        static let currentUserID = "currentUserID"
        static let natificationsEnabled = "notificationsEnabled"
    }
}
