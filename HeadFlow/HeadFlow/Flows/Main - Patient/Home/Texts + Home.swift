//
//  Texts + Home.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.03.2023.
//

import Foundation

extension Texts {
    struct Home {
        static let notificationsAlertTitle = NSLocalizedString("notifications_alert_title", value: "Notifications alert", comment: "")
        static let enableNotificationsAlertMessage = NSLocalizedString("enable_notifications_alert_message", value: "Push notifications are disabled on this device. To receive daily reminders to practice, you can enable notifications in settings.", comment: "")
        static let disableNotificationsAlertMessage = NSLocalizedString("disable_notifications_alert_message", value: "Daily reminders are enabled on this device. You can disable these notifications in settings.", comment: "")
        static let cancelButtonLabel = NSLocalizedString("cancel_button_label", value: "Cancel", comment: "")
        static let goToSettingsButtonLabel = NSLocalizedString("go_to_settings_button_label", value: "Go to settings", comment: "")
    }
}
