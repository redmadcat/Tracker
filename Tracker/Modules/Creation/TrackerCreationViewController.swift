//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 18.09.2025.
//

import UIKit

final class TrackerCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {    
    // MARK: - Definition
    var dataProvider: TrackerDataProviderProtocol?
    private var editMode: Bool = false
    private var oldCategory: TrackerCategory?
    private lazy var tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
    private lazy var footerView = UIStackView()
    
    private lazy var cancelButton = UIButton()
    private lazy var createButton = UIButton()
    
    private lazy var headerLabel = UILabel(
        text: self.editMode ? "Редактирование привычки" : "Новая привычка",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 16, weight: .medium),
        textAlighment: .center)
    
    private let counterLabel = UILabel(
        text: "",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 32, weight: .bold),
        textAlighment: .center)
            
    private let textLengthLimit = 38
    private var warningCellVisible: Bool = false
    private var trackerId: UUID?
    private var selectedCategory: String?
    private var selectedDays = [Int]()
    private var trackerName: String?
    private var trackerEmoji: String?
    private var trackerColor: UIColor?
        
    var onTrackerCreated: ((TrackerCategory) -> Void)?
    var onTrackerEdited: ((TrackerCategory, TrackerCategory?) -> Void)?
            
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureUI()
        configureLayout()
        updateCreateButtonStatus()
    }
    
    func edit(_ tracker: Tracker, with category: TrackerCategory, daysCount: Int) {
        editMode = true
        counterLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of days"), daysCount)
        oldCategory = category
        trackerId = tracker.id
        trackerName = tracker.name
        selectedDays = tracker.schedule
        trackerEmoji = tracker.emoji
        trackerColor = tracker.color
        selectedCategory = category.header
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return indexPath.row == 0 ?
                TrackerNameCell(style: .default, text: trackerName, delegate: self) :
                TrackerStubCell(style: .default)
        case 1:
            return indexPath.row == 0 ?
                TrackerCategoryCell(style: .subtitle, categoryHeader: selectedCategory) :
                TrackerScheduleCell(style: .subtitle, schedule: selectedDays)
        case 2:
            return indexPath.row == 0 ?
                TrackerEmojiListCell(style: .default, delegate: self, emoji: trackerEmoji) :
                TrackerColorListCell(style: .default, delegate: self, color: trackerColor)
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
        case 2:
            return 204 + 50
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.cellForRow(at: indexPath) {
        case let cell as TrackerCategoryCell:
            configureCell(at: cell)
        case let cell as TrackerScheduleCell:
            configureCell(at: cell)
        default:
            return
        }
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
    
    // MARK: - Color/Emoji Picker
    func setColor(_ color: UIColor) {
        trackerColor = color
        updateCreateButtonStatus()
    }
    
    func setEmoji(_ emoji: String) {
        trackerEmoji = emoji
        updateCreateButtonStatus()
    }
    
    // MARK: - Private func
    private func configureUI() {
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerNameCell.self, forCellReuseIdentifier: TrackerStubCell.reuseIdentifier)
        tableView.register(TrackerStubCell.self, forCellReuseIdentifier: TrackerStubCell.reuseIdentifier)
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.reuseIdentifier)
        tableView.register(TrackerScheduleCell.self, forCellReuseIdentifier: TrackerScheduleCell.reuseIdentifier)
        tableView.register(TrackerEmojiListCell.self, forCellReuseIdentifier: TrackerEmojiListCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // footerView
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        // cancelButton
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // createButton
        createButton.setTitle(editMode ? "Сохранить" : "Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.backgroundColor = .ypBlack
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .ypWhite
        
        // hierarchy
        footerView.addSubview(cancelButton)
        footerView.addSubview(createButton)
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(footerView)
    }
    
    private func configureLayout() {
        if editMode {
            view.addSubview(counterLabel)
            
            NSLayoutConstraint.activate([
                counterLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
                counterLabel.heightAnchor.constraint(equalToConstant: 38),
                counterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        }
                                
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                                            
            tableView.topAnchor.constraint(equalTo: editMode ? counterLabel.bottomAnchor : headerLabel.bottomAnchor, constant: 38),
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
    }
    
    private func configureCell(at cell: TrackerCategoryCell) {
        let categoryViewController = TrackerCategoryViewController()
        let viewModel = TrackerCategoryViewModel(provider: self.dataProvider)
        categoryViewController.initialize(viewModel: viewModel)
        categoryViewController.setCategory(selectedCategory)
        categoryViewController.onCategorySelected = { category in
            cell.detailTextLabel?.text = category
            self.selectedCategory = category
        }
        categoryViewController.modalPresentationStyle = .pageSheet
        present(categoryViewController, animated: true, completion: nil)
    }
    
    private func configureCell(at cell: TrackerScheduleCell) {
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
        createButton.isEnabled = !selectedDays.isEmpty && trackerIsValid() && !warningCellVisible
        createButton.backgroundColor = createButton.isEnabled ? .ypBlack : .ypGray
    }
    
    private func trackerIsValid() -> Bool {
        if let trackerName, let trackerEmoji {
            return !trackerName.isEmpty && !trackerEmoji.isEmpty && trackerColor != nil
        }
        return false
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        if let trackerName, let trackerEmoji, let trackerColor {
            var trackers = [Tracker]()
            trackers.append(Tracker(id: trackerId ?? UUID(), name: trackerName, color: trackerColor, emoji: trackerEmoji, schedule: selectedDays))
            let category = TrackerCategory(header: selectedCategory ?? "", trackers: trackers)
            editMode ? onTrackerEdited?(category, oldCategory) : onTrackerCreated?(category)
        }
        dismiss(animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    TrackerCreationViewController()
}
