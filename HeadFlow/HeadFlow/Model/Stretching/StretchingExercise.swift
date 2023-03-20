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
    var achievedRangeOfMotion: Int?
}

extension StretchingExercise {
    static let mock1: Self = .init(type: .tiltToRight, duration: 5)
}
