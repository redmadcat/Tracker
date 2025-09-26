//
//  Array+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.09.2025.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
    
    mutating func reduce(_ index: Element) where Element: Equatable {
        self = self.filter() { $0 != index }
    }
}
