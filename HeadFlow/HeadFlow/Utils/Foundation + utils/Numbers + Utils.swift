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
        
        if (self % 3600) / 60 != 0 {
            minutes = "\((self % 3600) / 60)"
        } else {
            minutes = "0"
        }
        
        let seconds = "\((self % 3600) % 60)"
        
        var finalString: String
        if minutes != "0" {
            finalString = "\(minutes) min"
            finalString.append("\(seconds) sec")
        } else {
            finalString = "\(seconds) sec"
        }
        
        return finalString
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
