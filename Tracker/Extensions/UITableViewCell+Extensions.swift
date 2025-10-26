//
//  UITableViewCell+Extensions.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 26.10.2025.
//

import UIKit

extension UITableViewCell {
    func roundTopBottomCornersFor(_ tableView: UITableView, with cell: UITableViewCell, at indexPath: IndexPath) {
        let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
        let isOnlyOneRow = indexPath.row == 0 && lastRow == 0
        
        cell.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 0)
        
        if isOnlyOneRow {
            cell.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 16)
            return
        }
                  
        switch indexPath.row {
        case 0:
            cell.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        case lastRow:
            cell.addBorder(to: .top, width: 0.5, color: .ypGray, inset: 20)
            cell.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
        default:
            cell.addBorder(to: .top, width: 0.5, color: .ypGray, inset: 20)
        }
    }
}
