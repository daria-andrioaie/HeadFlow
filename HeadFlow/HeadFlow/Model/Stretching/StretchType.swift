//
//  StretchType.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation

enum StretchType {
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
            return 0
        case .fullRotationLeft:
            return 0
        }
    }
}
