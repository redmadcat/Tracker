//
//  Calendar+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

import Foundation

extension Calendar {
    private static let local: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "ru_RU")
        return calendar
    }()
        
    static func weekdaySymbol(at index: Int) -> String? {
        return local.weekdaySymbols[safe: index]?.firstUppercased
    }
    
    static func shortWeedaySymbols(at range: [Int]) -> String {
        return local.shortWeekdaySymbols.elements(at: range).joined(separator: ", ")
    }
                        
    static func weekdayNumber(for date: Date) -> Int? {
        let weekday = local.component(.weekday, from: date)
        return local.weekdaySymbols.firstIndex(of: local.weekdaySymbols[weekday - 1])
    }
    
    static func weekdayIndex(at index: Int) -> Int {
        return index < weekdayCount - 1 ? index + 1 : 0
    }
    
    static let weekdayCount: Int = {
        return local.shortWeekdaySymbols.count
    }()
    
    static func range(for date: Date) -> (Date, Date)? {
        let from = local.startOfDay(for: date)
        guard let to = local.date(byAdding: .day, value: 1, to: from) else {
            return nil
        }
        return (from, to)
    }
}
