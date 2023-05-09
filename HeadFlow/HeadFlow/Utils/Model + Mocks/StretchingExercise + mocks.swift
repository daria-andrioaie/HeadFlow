//
//  StretchingExercise + mocks.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 19.04.2023.
//

import Foundation

extension StretchingExercise {
    static let mock1: Self = .init(type: .tiltToRight, duration: 5, goalDegrees: StretchType.tiltToRight.maximumDegrees, maximumDegrees: StretchType.tiltToRight.maximumDegrees)
    static let mock2: Self = .init(type: .tiltToLeft, duration: 5, goalDegrees: StretchType.tiltToRight.maximumDegrees, maximumDegrees: StretchType.tiltToRight.maximumDegrees)
    static let mock3: Self = .init(type: .rotateToRight, duration: 5, goalDegrees: StretchType.tiltToRight.maximumDegrees, maximumDegrees: StretchType.tiltToRight.maximumDegrees)

}
