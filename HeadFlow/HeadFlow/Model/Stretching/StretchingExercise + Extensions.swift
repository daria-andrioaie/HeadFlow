//
//  StretchingExercise + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 02.04.2023.
//

import Foundation

extension StretchingExercise: Codable {
    enum CodingKeys: String, CodingKey {
        case type = "exerciseType"
        case achievedRangeOfMotion = "rangeOfMotion"
        case duration
        case goalDegrees
        case maximumDegrees
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = StretchType(rawValue: try container.decode(String.self, forKey: .type)) ?? .unknown
        
        achievedRangeOfMotion = try container.decodeIfPresent(Double.self, forKey: .achievedRangeOfMotion)
        duration = try container.decode(Int.self, forKey: .duration)
        goalDegrees = try container.decode(Int.self, forKey: .goalDegrees)
        maximumDegrees = try container.decode(Int.self, forKey: .maximumDegrees)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(achievedRangeOfMotion ?? 0, forKey: .achievedRangeOfMotion)
        try container.encode(duration, forKey: .duration)
        try container.encode(goalDegrees, forKey: .goalDegrees)
        try container.encode(maximumDegrees, forKey: .maximumDegrees)
    }
}

extension StretchingExercise: Hashable, Identifiable {
    static func == (lhs: StretchingExercise, rhs: StretchingExercise) -> Bool {
        return lhs.type == rhs.type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String { self.type.rawValue }
}
