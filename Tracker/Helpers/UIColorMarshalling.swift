//
//  UIColorMarshalling.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 14.10.2025.
//

import UIKit

final class UIColorMarshalling {
    static func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }

    static func color(from hex: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func compare(color1: UIColor, color2: UIColor) -> Bool {
        UIColorMarshalling.hexString(from: color1) == UIColorMarshalling.hexString(from: color2)
    }
    
    static let gradient = [
        CGColor(red: 0.990, green: 0.300, blue: 0.290, alpha: 100),
        CGColor(red: 0.270, green: 0.900, blue: 0.620, alpha: 100),
        CGColor(red: 0.0, green: 0.480, blue: 0.980, alpha: 100)
    ]
}
