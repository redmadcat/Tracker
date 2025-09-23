//
//  Calendar+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

import Foundation

extension Calendar {
    private static let calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "ru_RU")
        return calendar
    }()
        
    static let weekday: [String] = {
        var weekdaySymbols = calendar.weekdaySymbols
        weekdaySymbols.append(weekdaySymbols.remove(at: weekdaySymbols.startIndex))
        return weekdaySymbols
    }()
}
