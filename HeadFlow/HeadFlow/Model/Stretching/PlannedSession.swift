//
//  PlannedSession.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 09.05.2023.
//

import Foundation

struct PlannedSession: Codable {
    let patientId: String
    let exerciseData: [StretchingExercise]
}

extension PlannedSession {
    static let defaultSession: [StretchingExercise] = [
        .init(type: .tiltToRight, duration: 5, goalDegrees: 45, maximumDegrees: 45),
        .init(type: .tiltToLeft, duration: 5, goalDegrees: 45, maximumDegrees: 45),
        .init(type: .tiltForward, duration: 5, goalDegrees: 45, maximumDegrees: 45),
        .init(type: .tiltBackwards, duration: 5, goalDegrees: 45, maximumDegrees: 45),
        .init(type: .rotateToRight, duration: 5, goalDegrees: 60, maximumDegrees: 60),
        .init(type: .rotateToLeft, duration: 5, goalDegrees: 60, maximumDegrees: 60)
//        .init(type: .fullRotationRight, duration: 5, goalDegrees: 45, maximumDegrees: 45),
//        .init(type: .fullRotationLeft, duration: 5, goalDegrees: 45, maximumDegrees: 45)
    ]
}
