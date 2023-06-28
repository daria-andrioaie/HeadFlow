//
//  StretchingSummary.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 24.03.2023.
//

import Foundation

extension StretchSummary {
    struct Model: Codable, Hashable, Identifiable {
        let id: String
        let averageRangeOfMotion: Double
        let duration: Int
        let exerciseData: [StretchingExercise]
        let date: Int64
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case averageRangeOfMotion
            case duration
            case exerciseData
            case date
        }
    }
}

extension StretchSummary.Model {
    static let mock1 = StretchSummary.Model(id: "1", averageRangeOfMotion: 0.87, duration: 125, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 - 86_400_000)
    static let mock9 = StretchSummary.Model(id: "9", averageRangeOfMotion: 0.7, duration: 125, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 - 86_400_000 + 61)
    static let mock2 = StretchSummary.Model(id: "2", averageRangeOfMotion: 0.53, duration: 168, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 - 2 * 86_400_000)
    static let mock3 = StretchSummary.Model(id: "3", averageRangeOfMotion: 0.12, duration: 225, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 - 3 * 86_400_000)
    static let mock4 = StretchSummary.Model(id: "4", averageRangeOfMotion: 0.23, duration: 321, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 + 4 * 86_400_000)
    static let mock5 = StretchSummary.Model(id: "5", averageRangeOfMotion: 0.43, duration: 321, exerciseData: [.mock1], date: Date.now.millisecondsSince1970)
    static let mock6 = StretchSummary.Model(id: "6", averageRangeOfMotion: 0.65, duration: 321, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 + 3 * 86_400_000)
    static let mock7 = StretchSummary.Model(id: "7", averageRangeOfMotion: 0.11, duration: 321, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 + 2 * 86_400_000)
    static let mock8 = StretchSummary.Model(id: "8", averageRangeOfMotion: 0.78, duration: 321, exerciseData: [.mock1], date: Date.now.millisecondsSince1970 + 86_400_000)
    static let mockedSet: [Self] = [.mock1, .mock2, .mock3, .mock4, .mock5, .mock6, .mock7, .mock8, .mock9]
}
