//
//  Int+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 06.10.2025.
//

extension Int {
    var daysWordForm: String {
        let remainder10 = self % 10
        let remainder100 = self % 100

        if remainder10 == 1 && remainder100 != 11 {
            return "\(self) день"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "\(self) дня"
        } else {
            return "\(self) дней"
        }
    }
}
