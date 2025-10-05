//
//  TrackerCardCellDelegate.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 01.10.2025.
//

import Foundation

protocol TrackerCardCellDelegate: AnyObject {
    func setCompletionTo(completion: Bool, with id: UUID, at indexPath: IndexPath)
}
