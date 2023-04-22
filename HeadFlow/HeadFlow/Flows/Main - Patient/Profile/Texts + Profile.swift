//
//  Texts + Profile.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import Foundation

extension Texts {
    struct PatientProfile {
        static let therapistCollabMenuLabel = NSLocalizedString("therapist_collab_menu_label", value: "Your therapist", comment: "")
        static let disableNotificationsAlertMessage = NSLocalizedString("disable_notifications_alert_message", value: "Daily reminders are enabled on this device. You can disable these notifications in settings.", comment: "")
        static let cancelButtonLabel = NSLocalizedString("cancel_button_label", value: "Cancel", comment: "")
        static let goToSettingsButtonLabel = NSLocalizedString("go_to_settings_button_label", value: "Go to settings", comment: "")
    }
}


extension Texts {
    struct GeneralProfile {
        static let profileNavbarTitle = NSLocalizedString("profile_navbar_title", value: "Profile", comment: "")
        static let editProfileMenuLabel = NSLocalizedString("edit_profile_menu_label", value: "Edit profile", comment: "")
        static let logoutButtonLabel = NSLocalizedString("logout_button_label", value: "Logout", comment: "")
    }
}
