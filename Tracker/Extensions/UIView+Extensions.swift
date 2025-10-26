//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.09.2025.
//

import UIKit
import Foundation

extension UIView {
    static var reuseIdentifier: String {
        return String(describing: self.self)
    }
    
    enum Side {
        case top
        case left
        case bottom
        case right
    }
            
    func addBorder(to: Side, width borderWidth: CGFloat, color: UIColor?, inset: CGFloat = 0) {
        let border = UIView()
        border.backgroundColor = color
        
        switch to {
        case .top:
            border.frame = CGRect(x: inset, y: 0, width: frame.size.width - (inset * 2.0), height: borderWidth)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        case .bottom:
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            border.frame = CGRect(x: inset, y: frame.size.height - borderWidth, width: frame.size.width - (inset * 2.0), height: borderWidth)
        case .right:
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        }
        addSubview(border)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
