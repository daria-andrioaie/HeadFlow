//
//  Numbers + Utils.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 25.03.2023.
//

import Foundation

extension Int {
    func toHoursAndMinutesFormat() -> String {
        let hour: String
        if (self / 3600) / 10 == 0 {
            hour = "0\((self / 3600))"
        }
        else {
            hour = "\((self / 3600))"
        }
        
        let minute: String
        if ((self % 3600) / 60) / 10 == 0 {
            minute = "0\((self % 3600) / 60)"
        }
        else {
            minute = "\((self % 3600) / 60)"
        }
        
        return "\(hour):\(minute)"
    }
}

extension Int64 {
    func toCalendarDate() -> String {
        return Date(milliseconds: self).formatted(date: .abbreviated, time: .omitted)
    }
}

extension Double {
    func toPercentage() -> String {
        return String(format: "%.2f", self * 100)
    }
}
