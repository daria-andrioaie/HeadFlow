//
//  StretchType.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation

enum StretchType: CaseIterable {
    case tiltToRight, tiltToLeft
    case tiltForward, tiltBackwards
    case rotateToRight, rotateToLeft
    case fullRotationRight, fullRotationLeft
    
    var totalRangeOfMotion: Int {
        switch self {
        case .tiltToRight:
            return 47
        case .tiltToLeft:
            return 47
        case .tiltForward:
            return 70
        case .tiltBackwards:
            return 23
        case .rotateToRight:
            return 60
        case .rotateToLeft:
            return 60
            
        //TODO: figure out how to compute these to
        case .fullRotationRight:
            return 10
        case .fullRotationLeft:
            return 10
        }
    }
    
    var title: String {
        switch self {
        case .tiltToRight: return "Tilt head to right"
        case .tiltToLeft: return "Tilt head to left"
        case .tiltForward: return "Tilt head forward"
        case .tiltBackwards: return "Tilt head backwards"
        case .rotateToRight: return "Look to the right right"
        case .rotateToLeft: return "Look to the left"
        case .fullRotationRight: return "Full circle to right"
        case .fullRotationLeft: return "Full circle to left"
        }
    }
}
