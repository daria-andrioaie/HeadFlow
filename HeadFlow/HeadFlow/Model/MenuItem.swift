//
//  MenuItem.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 22.04.2023.
//

import Foundation
import SwiftUI

enum MenuItem: Hashable, Identifiable {
    var id: Self {
        return self
    }
    
    case therapistCollaboration
    case editProfile
        
    var title: String {
        switch self {
        case .editProfile: return Texts.GeneralProfile.editProfileMenuLabel
        case .therapistCollaboration: return Texts.PatientProfile.therapistCollabMenuLabel
        }
    }
    
    var image: Image {
        let hfImage: HFImage
        switch self {
        case .editProfile: hfImage = .userProfile
        case .therapistCollaboration: hfImage = .stethoscope
        }
        return Image(hfImage)
    }
}
