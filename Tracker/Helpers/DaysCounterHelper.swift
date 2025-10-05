//
//  DaysCounterHelper.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 05.10.2025.
//

func numberToStringDaysForm(to count: Int) -> String {
    let remainder10 = count % 10
    let remainder100 = count & 100
    
    if remainder10 == 1 && remainder100 != 11 {
        return "\(count) день"
    } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
        return "\(count) дня"
    } else {
        return "\(count) дней"
    }
}
