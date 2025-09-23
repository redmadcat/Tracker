//
//  StringProtocol+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
}
