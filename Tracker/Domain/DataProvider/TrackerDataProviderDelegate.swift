//
//  TrackerDataProviderDelegate.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

import Foundation

protocol TrackerDataProviderDelegate: AnyObject {
    func store(_ store: TrackerDataProvider?, newIndexPath: IndexPath?)
}
