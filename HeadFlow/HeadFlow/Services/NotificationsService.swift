//
//  NotificationsService.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.03.2023.
//

import Foundation
import RealmSwift

protocol NotificationsServiceProtocol {
    func saveNotificationsStatusOfUser(userId: String, notificationsStatusPresented: Bool)
}

class NotificationsService: NotificationsServiceProtocol {
    func saveNotificationsStatusOfUser(userId: String, notificationsStatusPresented: Bool) {
        let realm = try! Realm()
        let permissions = realm.objects(NotificationsPermissions.self)
        if !permissions.contains(where: { $0.userID == userId}) {
            let permissionsStatus = NotificationsPermissions()
            permissionsStatus.userID = userId
            permissionsStatus.notificationsStatusPresented = notificationsStatusPresented
            
            try! realm.write {
                realm.add(permissionsStatus)
            }
        }
    }
}

class MockNotificationsService: NotificationsServiceProtocol {
    func saveNotificationsStatusOfUser(userId: String, notificationsStatusPresented: Bool) { }
}
