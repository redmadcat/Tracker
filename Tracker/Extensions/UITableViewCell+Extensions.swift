//
//  UITableViewCell+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 24.09.2025.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self.self)
    }
}
