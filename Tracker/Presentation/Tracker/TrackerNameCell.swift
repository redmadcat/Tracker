//
//  TrackerNameCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerNameCell: UITableViewCell {
    // MARK: - Definition
    static let reuseIdentifier = "TrackerNameCell"
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(
                    frame: CGRect(
                        x: 0, y: 0, width: 16, height: textField.frame.height))
                
        textField.backgroundColor = .ypBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlack
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 0
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        return textField
    }()
                        
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
