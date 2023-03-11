//
//  HomeViewModel.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 05.03.2023.
//

import Foundation
import UserNotifications
import RealmSwift
import UIKit

extension Home {
    class ViewModel: ObservableObject {
        @Published var apiError: Error?
        @Published var isConfirmationMessagePresented: Bool = false
        @Published var showNotificationsAlert: Bool = false
        @Published var notificationsStatus: NotificationsStatusType = .disabled
        var confirmationMessage: String = ""
        
        var notificationsAlertMessage: String {
            notificationsStatus == .disabled ? Texts.Home.enableNotificationsAlertMessage : Texts.Home.disableNotificationsAlertMessage
        }
        
        let authenticationService: AuthenticationServiceProtocol
        
        let onLogout: () -> Void
        
        init(authenticationService: AuthenticationServiceProtocol, onLogout: @escaping () -> Void) {
            self.authenticationService = authenticationService
            self.onLogout = onLogout
        }
        
        func logout() {
            Task(priority: .userInitiated) { @MainActor in
                await authenticationService.logout { [unowned self] result in
                    switch result {
                    case .success(let message):
                        self.isConfirmationMessagePresented = true
                        confirmationMessage = message
                        DispatchQueue.main.asyncAfter(seconds: 2) {
                            self.onLogout()
                        }
                    case .failure(let error):
                        apiError = Errors.CustomError(error.message)
                    }
                }
            }
        }
        
        func openSettings() {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.tryOpen(url: settingsUrl)
        }
        
        func setupNotifications() {
            let notificationsCenter = UNUserNotificationCenter.current()
            
            notificationsCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    notificationsCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                        guard let currentUserId = Session.shared.currentUserID else {
                            return
                        }
                        
                        let realm = try! Realm()
                        
                        let permissionsForCurrentUser = realm.objects(NotificationsPermissions.self).filter("userID = %@", currentUserId).first
                        
                        if let permissionsForCurrentUser {
                            try! realm.write {
                                permissionsForCurrentUser.notificationsStatusPresented = true
                            }
                        }
                    }
                case .denied:
                    guard let currentUserId = Session.shared.currentUserID else {
                        return
                    }
                    
                    let realm = try! Realm()
                    
                    let permissions = realm.objects(NotificationsPermissions.self)
                    
                    let permissionsForCurrentUser = permissions.first { $0.userID == currentUserId }
                    if let permissionsForCurrentUser {
                        if !permissionsForCurrentUser.notificationsStatusPresented {
                            DispatchQueue.main.async {
                                self.notificationsStatus = .disabled
                                self.showNotificationsAlert = true
                            }
                            
                            try! realm.write {
                                permissionsForCurrentUser.notificationsStatusPresented = true
                            }
                        }
                    }
                case .authorized:
                    guard let currentUserId = Session.shared.currentUserID else {
                        return
                    }
                    
                    let realm = try! Realm()
                    
                    let permissions = realm.objects(NotificationsPermissions.self)
                    
                    let permissionsForCurrentUser = permissions.first { $0.userID == currentUserId }
                    if let permissionsForCurrentUser {
                        if !permissionsForCurrentUser.notificationsStatusPresented {
                            DispatchQueue.main.async {
                                self.notificationsStatus = .enabled
                                self.showNotificationsAlert = true
                            }
                            
                            try! realm.write {
                                permissionsForCurrentUser.notificationsStatusPresented = true
                            }
                        }
                    }
                default:
                    return
                }
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Ready for a new day?"
            content.body = "Start with some movement!"
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "daily-cta", content: content, trigger: trigger)
            
            notificationsCenter.add(request) { error in
                if let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
