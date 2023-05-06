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
    case fullRotationRight, fullRotationLeft
    case unknown
    
    var totalRangeOfMotion: Int {
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
            
        //TODO: figure out how to compute these two
        case .fullRotationRight:
            return 10
        case .fullRotationLeft:
            return 10
            
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
        case .fullRotationRight: return "Full circle to right"
        case .fullRotationLeft: return "Full circle to left"
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
        case .fullRotationRight: return "Counter-clockwise rotation"
        case .fullRotationLeft: return "Clockwise rotation"
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
        case .fullRotationRight: return .rotateRIght
        case .fullRotationLeft: return .rotateLeft
        case .unknown: return .tiltLeft
        }
    }
}
