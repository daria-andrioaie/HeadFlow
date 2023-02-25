//
//  Texts + Login.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import Foundation

extension Texts {
    struct PhoneNumberInput {
        static let loginGreetingsLabel = NSLocalizedString("login_greeting_label", value: "Welcome back! 👋🏼", comment: "")
        static func signupGreetingsLabel(name: String) -> String { NSLocalizedString("signup_greeting_label", value: "Hi there, \(name)!👋🏼", comment: "") }

        static let loginLabel = NSLocalizedString("login_label", value: "Let's get you logged in.", comment: "")
        static let signupLabel = NSLocalizedString("signup_label", value: "Let's confirm your mobile number.", comment: "")

        static let phoneFieldPlaceholder = NSLocalizedString("phone_field_placeholder", value: "Enter your phone number", comment: "")
        static let loginAlternativesLabel = NSLocalizedString("login_alternatives_label", value: "Or log in with:", comment: "")
        static let signupAlternativesLabel = NSLocalizedString("signup_alternatives_label", value: "Or sign up with:", comment: "")
        static let nextButtonLabel = NSLocalizedString("next_button_label", value: "Next", comment: "")
    }
}
