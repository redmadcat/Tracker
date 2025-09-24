//
//  TrackerNameCell.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerNameCell: UITableViewCell {
    // MARK: - Definition
    private weak var delegate: UITextFieldDelegate?
    
    private lazy var textField: UITextField = {
        let textField = TrackerTextField()
        textField.backgroundColor = .ypBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlack
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 0
        textField.delegate = delegate
        textField.returnKeyType = UIReturnKeyType.go
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = false
        return textField
    }()
                        
    // MARK: - Lifecycle
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerNameCell.reuseIdentifier, delegate: UITextFieldDelegate?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.delegate = delegate
        
        selectionStyle = .none
        contentView.addSubview(textField)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.becomeFirstResponder()
    }
}
