//
//  StretchingSummary.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 24.03.2023.
//

import Foundation

extension StretchSummary {
    struct Model: Codable, Hashable, Identifiable {
        var id: Int64 { return date }
        
        let averageRangeOfMotion: Double
        let duration: Int
        let date: Int64
    }
}

extension StretchSummary.Model {
    static let mock1 = StretchSummary.Model(averageRangeOfMotion: 0.87, duration: 125, date: Date.now.millisecondsSince1970 - 86_400_000)
    static let mock2 = StretchSummary.Model(averageRangeOfMotion: 0.53, duration: 168, date: Date.now.millisecondsSince1970 - 2 * 86_400_000)
    static let mock3 = StretchSummary.Model(averageRangeOfMotion: 0.12, duration: 225, date: Date.now.millisecondsSince1970 - 3 * 86_400_000)
    static let mock4 = StretchSummary.Model(averageRangeOfMotion: 0.23, duration: 321, date: Date.now.millisecondsSince1970 + 4 * 86_400_000)
    static let mock5 = StretchSummary.Model(averageRangeOfMotion: 0.43, duration: 321, date: Date.now.millisecondsSince1970)
    static let mock6 = StretchSummary.Model(averageRangeOfMotion: 0.65, duration: 321, date: Date.now.millisecondsSince1970 + 3 * 86_400_000)
    static let mock7 = StretchSummary.Model(averageRangeOfMotion: 0.11, duration: 321, date: Date.now.millisecondsSince1970 + 2 * 86_400_000)
    static let mock8 = StretchSummary.Model(averageRangeOfMotion: 0.78, duration: 321, date: Date.now.millisecondsSince1970 + 86_400_000)
    static let mockedSet: [Self] = [.mock1, .mock2, .mock3, .mock4, .mock5, .mock6, .mock7, .mock8]
}
