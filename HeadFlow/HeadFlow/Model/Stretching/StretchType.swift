//
//  StretchType.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation

enum StretchType: String, CaseIterable {
    case tiltToRight, tiltToLeft
    case tiltForward, tiltBackwards
    case rotateToRight, rotateToLeft
    case unknown
    
    /// !!! to be used only for mocking purposes !!!
    var maximumDegrees: Int {
        switch self {
        case .tiltToRight:
            return 45
        case .tiltToLeft:
            return 45
        case .tiltForward:
            return 45
        case .tiltBackwards:
            return 45
        case .rotateToRight:
            return 60
        case .rotateToLeft:
            return 60
            
        case .unknown:
            return 0
        }
    }
    
    var prompt: String {
        switch self {
        case .tiltToRight: return "Tilt head to right"
        case .tiltToLeft: return "Tilt head to left"
        case .tiltForward: return "Tilt head forward"
        case .tiltBackwards: return "Tilt head backwards"
        case .rotateToRight: return "Look to the right"
        case .rotateToLeft: return "Look to the left"
        case .unknown: return "unknown"
        }
    }
    
    var title: String {
        switch self {
        case .tiltToRight: return "Right lateral flexion"
        case .tiltToLeft: return "Left lateral flexion"
        case .tiltForward: return "Forward flexion"
        case .tiltBackwards: return "Backwards extension"
        case .rotateToRight: return "Right axial rotation"
        case .rotateToLeft: return "Left axial rotation"
        case .unknown: return "unknown"
        }
    }
    
    var image: HFImage {
        switch self {
        case .tiltToRight: return .tiltLeft
        case .tiltToLeft: return .tiltRight
        case .tiltForward: return .tiltForward
        case .tiltBackwards: return .tiltBackwards
        case .rotateToRight: return .rotateRIght
        case .rotateToLeft: return .rotateLeft
        case .unknown: return .tiltLeft
        }
    }
}
