//
//  TrackerDataProviderDelegate.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

protocol TrackerDataProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}
