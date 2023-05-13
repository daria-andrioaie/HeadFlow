//
//  Numbers + Utils.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import Foundation

extension Int {
    func toMinutesAndSecondsFormat() -> String {
        let minutes: String
        if ((self % 3600) / 60) / 10 == 0 {
            minutes = "0\((self % 3600) / 60)"
        }
        else {
            minutes = "\((self % 3600) / 60)"
        }
        
        let seconds: String
        if ((self % 3600) % 60) / 10 == 0 {
            seconds = "0\((self % 3600) % 60)"
        } else {
            seconds = "\((self % 3600) % 60)"
        }
        
        return "\(minutes):\(seconds)"
    }
}

extension Int64 {
    func toCalendarDate(_ formatStyle: Date.FormatStyle.DateStyle = .abbreviated) -> String {
        return Date(milliseconds: self).formatted(date: formatStyle, time: .omitted)
    }
}

extension Double {
    func toPercentage() -> String {
        return String(format: "%.0f", self * 100)
    }
}
