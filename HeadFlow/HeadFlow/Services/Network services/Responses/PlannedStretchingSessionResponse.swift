//
//  PlannedStretchigSessionResponse.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 08.05.2023.
//

import Foundation

struct PlannedStretchingSessionResponse: Decodable {
    let success: Bool
    let plannedSession: [StretchingExercise]
}
