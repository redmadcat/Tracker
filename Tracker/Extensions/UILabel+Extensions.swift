//
//  UILabel+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 09.09.2025.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, font: UIFont = .systemFont(ofSize: 13)) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
