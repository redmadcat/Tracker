//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {    
    // MARK: - Definition
    private lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerNameCell.self, forCellReuseIdentifier: TrackerStubCell.reuseIdentifier)
        tableView.register(TrackerStubCell.self, forCellReuseIdentifier: TrackerStubCell.reuseIdentifier)
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.reuseIdentifier)
        tableView.register(TrackerScheduleCell.self, forCellReuseIdentifier: TrackerScheduleCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var footerView: UIStackView = {
        let footerView = UIStackView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(cancelButton)
        footerView.addSubview(createButton)
        return footerView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.backgroundColor = .ypBlack
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private let headerLabel: UILabel = {
        return UILabel(
            text: "Новая привычка",
            textColor: .ypBlack,
            font:.systemFont(ofSize: 16, weight: .medium),
            textAlighment: .center)
    }()
    
    private let textLengthLimit = 38
    private var warningCellVisible: Bool = false
    private var selectedDays = [Int]()
    private var trackerName: String?
        
    var onTrackerCreated: ((TrackerCategory) -> Void)?
            
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        configureLayout()
        updateCreateButtonStatus()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return indexPath.row == 0 ?
                TrackerNameCell(style: .default, delegate: self) :
                TrackerStubCell(style: .default)
        case 1:
            return indexPath.row == 0 ?
                TrackerCategoryCell(style: .subtitle) :
                TrackerScheduleCell(style: .subtitle)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return indexPath.row == 0 ? 75 : warningCellVisible ? 62 : 24
        case 1:
            return indexPath.row == 0 || indexPath.row == 1 ? 75 : 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TrackerScheduleCell  else { return }
        let scheduleViewController = TrackerScheduleViewController()
        scheduleViewController.setDays(selectedDays)
        scheduleViewController.onScheduleSelected = { selectedDays in
            cell.setDetailsBased(on: selectedDays)
            self.selectedDays = selectedDays
            self.updateCreateButtonStatus()
        }
        scheduleViewController.modalPresentationStyle = .pageSheet
        present(scheduleViewController, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackerName = textField.text
        updateCreateButtonStatus()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateWarningCellVisibilityTo(false)
        return true
    }
                    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let textLength = text.count + string.count - range.length
        let shouldWarn = textLength <= textLengthLimit ? false : true
        updateWarningCellVisibilityTo(shouldWarn)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
                
    // MARK: - Private func
    private func configureLayout() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.widthAnchor.constraint(equalToConstant: 133),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            cancelButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            createButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8)
        ])
        
        view.backgroundColor = .ypWhite
    }
    
    private func updateWarningCellVisibilityTo(_ value: Bool, at indexPath: IndexPath = IndexPath(row: 1, section: 0)) {
        if warningCellVisible != value {
            warningCellVisible = value
            tableView.reloadRows(at: [indexPath], with: .fade)
            if let cell = tableView.cellForRow(at: indexPath) as? TrackerStubCell {
                cell.showWarning(value)
            }
        }
    }
    
    private func updateCreateButtonStatus() {
        createButton.isEnabled = !selectedDays.isEmpty && trackerNameIsValid() && !warningCellVisible
        createButton.backgroundColor = createButton.isEnabled ? .ypBlack : .ypGray
    }
    
    private func trackerNameIsValid() -> Bool {
        if let trackerName {
            return !trackerName.isEmpty
        }
        return false
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        if let trackerName {
            var trackers = [Tracker]()
            trackers.append(Tracker(id: UUID(), name: trackerName, color: .ypSelection5, emoji: "", schedule: selectedDays))
            let category = TrackerCategory(header: "", trackers: trackers)
            onTrackerCreated?(category)
        }
        dismiss(animated: true)
    }
}

#Preview {
    TrackerCreationViewController()
}
