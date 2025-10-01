//
//  Int+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 01.10.2025.
//

extension Int {
    var daysCountDescription: String {
        let lastDigit = self % 10
        let lastTwoDigits = self % 100

        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "\(self) дней"
        } else if lastDigit == 1 {
            return "\(self) день"
        } else if (2...4).contains(lastDigit) {
            return "\(self) дня"
        } else {
            return "\(self) дней"
        }
    }
}
