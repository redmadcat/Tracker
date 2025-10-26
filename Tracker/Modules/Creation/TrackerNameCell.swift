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
    private lazy var textField = TrackerTextField()
                        
    // MARK: - Lifecycle
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = TrackerNameCell.reuseIdentifier, text: String?, delegate: UITextFieldDelegate?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.delegate = delegate
        textField.text = text
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Private func
    private func configureUI() {
        // textField
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
                
        selectionStyle = .none
        
        // hierarchy
        contentView.addSubview(textField)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
