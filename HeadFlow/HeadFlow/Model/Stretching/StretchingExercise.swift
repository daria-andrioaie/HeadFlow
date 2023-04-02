//
//  StretchingExercise.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 16.03.2023.
//

import Foundation

struct StretchingExercise {
    let type: StretchType
    let duration: Int
    var achievedRangeOfMotion: Double?
    
    init(type: StretchType, duration: Int, achievedRangeOfMotion: Double? = nil) {
        self.type = type
        self.duration = duration
        self.achievedRangeOfMotion = achievedRangeOfMotion
    }
}
