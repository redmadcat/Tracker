//
//  RandomAccessCollection+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 26.09.2025.
//

extension RandomAccessCollection {
    func elements(at indices: [Index]) -> [Element] { indices.map { self[$0] } }
}
