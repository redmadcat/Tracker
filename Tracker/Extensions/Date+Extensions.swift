//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 05.10.2025.
//

import Foundation

extension Date {
    func isLessThan(date: Date, granularity: Calendar.Component) -> Bool {
        let order = NSCalendar.current.compare(self, to: date, toGranularity: granularity)
        switch order {
        case .orderedDescending:
            return false
        default:
            return true
        }
    }
}
