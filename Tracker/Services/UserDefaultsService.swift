//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 30.10.2025.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    private enum Key {
        static let skipFurther = "skipFurther"
        static let filterIndex = "filterIndex"
    }
    
    private init() {}
    
    var isSkipFutherCompleted: Bool {
        get { defaults.bool(forKey: Key.skipFurther) }
        set { defaults.set(newValue, forKey: Key.skipFurther) }
    }
    
    var filterIndex: Int {
        get { defaults.integer(forKey: Key.filterIndex) }
        set { defaults.set(newValue, forKey: Key.filterIndex) }
    }
}
