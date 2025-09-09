//
//  UIButton+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.09.2025.
//

import UIKit

extension UIButton {
    static func createCustomButton(withImage named: String)
        -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: named) ?? UIImage(), for: .normal)
        return button
    }
}
