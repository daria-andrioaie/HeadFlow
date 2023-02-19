//
//  CarouselItem.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.02.2023.
//

import Foundation
import SwiftUI

extension Onboarding {
    enum CarouselItem: CaseIterable {
        case mobility
        case posture
        case sleep
        
        var index: Int {
            switch self {
            case .mobility:
                return 0
            case .posture:
                return 1
            case .sleep:
                return 2
            }
        }
        
        var image: Image {
            let hfImage: HFImage
            switch self {
            case .mobility: hfImage = .mobility
            case .posture: hfImage = .posture
            case .sleep: hfImage = .sleep
            }
            
            return Image(hfImage)
        }
        
        var title: String {
            switch self {
            case .mobility:
                return Texts.Onboarding.mobilityTitle
            case .posture:
                return Texts.Onboarding.postureTitle
            case .sleep:
                return Texts.Onboarding.sleepTitle
            }
        }
        
        var subtitle: String {
            switch self {
            case .mobility:
                return Texts.Onboarding.mobilitySubtitle
            case .posture:
                return Texts.Onboarding.postureSubtitle
            case .sleep:
                return Texts.Onboarding.sleepSubtitle
            }
        }
        
        var clipShape: any Shape {
            switch self {
            case .mobility:
                return RoundedRectangle(cornerRadius: 20)
            case .posture:
                return Ellipse()
            case .sleep:
                return Circle()
            }
        }
    }
}
