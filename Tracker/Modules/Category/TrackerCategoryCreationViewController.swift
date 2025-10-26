//
//  TrackerCategoryCreationViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 23.10.2025.
//

import UIKit

final class TrackerCategoryCreationViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Definition
    private let headerLabel = UILabel(
        text: "Новая категория",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 16, weight: .medium),
        textAlighment: .center)
    
    private lazy var doneButton = UIButton()
    private lazy var textField = TrackerTextField()
    private var categoryHeader: String?
    var onCategoryCreated: ((TrackerCategory) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        updateDoneButtonStatus()
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        categoryHeader = text
        doneButton.isEnabled = !text.isEmpty ? true : false
        updateDoneButtonStatus()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Private func
    private func configureUI() {
        // doneButton
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.backgroundColor = .ypBlack
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.isEnabled = false
        
        // textField
        textField.backgroundColor = .ypBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название категории"
        textField.textColor = .ypBlack
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 0
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.go
        textField.clearButtonMode = .never
        textField.clearsOnBeginEditing = false
                
        view.backgroundColor = .ypWhite
        
        // hierarchy
        view.addSubview(headerLabel)
        view.addSubview(textField)
        view.addSubview(doneButton)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.widthAnchor.constraint(equalToConstant: 133),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 94),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateDoneButtonStatus() {
        doneButton.backgroundColor = doneButton.isEnabled ? .ypBlack : .ypGray
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        if let categoryHeader {
            onCategoryCreated?(TrackerCategory(header: categoryHeader, trackers: []))
            dismiss(animated: true)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    TrackerCategoryCreationViewController()
}
