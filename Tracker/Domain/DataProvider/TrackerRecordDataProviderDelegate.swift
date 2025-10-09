//
//  TrackerRecordDataProviderDelegate.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.10.2025.
//

protocol TrackerRecordDataProviderDelegate: AnyObject {
    func update(_ update: TrackerRecordUpdate)
}
