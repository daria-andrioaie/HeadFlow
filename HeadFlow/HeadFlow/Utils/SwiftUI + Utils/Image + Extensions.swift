//
//  Image + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.02.2023.
//

import Foundation
import SwiftUI

enum HFImage: String {
    //MARK: images
    case mobility = "mobility-clipped"
    case posture = "posture-clipped"
    case sleep = "sleep-clipped"
    case airpods = "airpods"
    case shoudler_shrug = "shoulder-shrugging"
    
    //MARK: icons
    case chevronRight = "chevron-right"
    case chevronRightBold = "chevron-right-bold"
    case checkIcon = "check-icon-light"
    case userProfile = "user-profile"
    case userProfileFilled = "user-profile-filled"
    case userAddLight = "user-add-light"
    case bell = "bell"
    case stethoscope = "stethoscope-light"
    case logoutIcon = "logout-icon"
    case shareIcon = "share-icon"
    case checkmarkIcon = "checkmark-round-light"
    case closeIcon = "close-round-light"

    //MARK: social icons
    case appleIcon = "apple-icon"
    case googleIcon = "google-icon"
    case facebookIcon = "facebook-icon"
}

extension Image {
    init(_ hfImage: HFImage) {
        self.init(hfImage.rawValue)
    }
}
