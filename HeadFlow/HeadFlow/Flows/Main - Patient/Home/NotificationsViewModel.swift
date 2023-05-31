//
//  NotificationsSetup.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation
import UserNotifications
import RealmSwift
import UIKit

class NotificationsViewModel: ObservableObject {
    @Published var isNotificationsAlertPresented: Bool = false
    @Published var notificationsStatus: NotificationsStatusType = .disabled
    
    var notificationsAlert: Alert {
        notificationsStatus == .disabled ?
        Alert.init(title: Texts.Home.notificationsAlertTitle, message: Texts.Home.enableNotificationsAlertMessage) :
        Alert.init(title: Texts.Home.notificationsAlertTitle, message: Texts.Home.disableNotificationsAlertMessage)
        
    }
    enum NotificationsStatusType: String {
        case enabled, disabled
    }
    
    func openSettings() {
        if #available(iOS 16.0, *) {
            guard let settingsUrl = URL(string: UIApplication.openNotificationSettingsURLString) else {
                return
            }
            UIApplication.shared.tryOpen(url: settingsUrl)

        } else {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.tryOpen(url: settingsUrl)
        }
    }
    
    func setupNotifications() {
        let notificationsCenter = UNUserNotificationCenter.current()
        
        notificationsCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationsCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    guard let currentUserId = Session.shared.currentUser?.id else {
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
                guard let currentUserId = Session.shared.currentUser?.id else {
                    return
                }
                
                let realm = try! Realm()
                
                let permissions = realm.objects(NotificationsPermissions.self)
                
                let permissionsForCurrentUser = permissions.first { $0.userID == currentUserId }
                if let permissionsForCurrentUser {
                    if !permissionsForCurrentUser.notificationsStatusPresented {
                        DispatchQueue.main.async {
                            self.notificationsStatus = .disabled
                            self.isNotificationsAlertPresented = true
                        }
                        
                        try! realm.write {
                            permissionsForCurrentUser.notificationsStatusPresented = true
                        }
                    }
                }
            case .authorized:
                guard let currentUserId = Session.shared.currentUser?.id else {
                    return
                }
                
                let realm = try! Realm()
                
                let permissions = realm.objects(NotificationsPermissions.self)
                
                let permissionsForCurrentUser = permissions.first { $0.userID == currentUserId }
                if let permissionsForCurrentUser {
                    if !permissionsForCurrentUser.notificationsStatusPresented {
                        DispatchQueue.main.async {
                            self.notificationsStatus = .enabled
                            self.isNotificationsAlertPresented = true
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
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        notificationsCenter.removePendingNotificationRequests(withIdentifiers: ["daily-cta"])
        let request = UNNotificationRequest(identifier: "daily-cta", content: content, trigger: trigger)
        
        notificationsCenter.add(request) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
