//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Roman Yaschenkov on 04.11.2025.
//


import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testMainTrackersViewControllerLight() {
        let trackersViewController = TabBarController()
        assertSnapshot(of: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
        
    func testMainTrackersViewControllerLightDark() {
        let trackersViewController = TabBarController()
        assertSnapshot(of: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
