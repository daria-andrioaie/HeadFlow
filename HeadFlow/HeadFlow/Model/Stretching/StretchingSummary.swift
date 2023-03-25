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
    static let mock1 = StretchSummary.Model(averageRangeOfMotion: 0.23, duration: 125, date: Date.now.millisecondsSince1970)
    static let mock2 = StretchSummary.Model(averageRangeOfMotion: 0.46, duration: 168, date: Date.now.millisecondsSince1970)
    static let mock3 = StretchSummary.Model(averageRangeOfMotion: 0.56, duration: 225, date: Date.now.millisecondsSince1970)
    static let mock4 = StretchSummary.Model(averageRangeOfMotion: 0.72, duration: 321, date: Date.now.millisecondsSince1970)
}
