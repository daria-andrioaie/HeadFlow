//
//  NotificationsPermissions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 08.03.2023.
//

import Foundation
import RealmSwift

class NotificationsPermissions: Object {
    @Persisted var userID: String
    @Persisted var notificationsStatusPresented: Bool
}
