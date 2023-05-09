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
