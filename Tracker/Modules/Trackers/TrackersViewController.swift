//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.09.2025.
//

import UIKit
import Foundation

final class TrackersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
                                    TrackerCardCellDelegate, TrackerDataProviderDelegate {
    // MARK: - Definition
    var dataProvider: TrackerDataProviderProtocol?
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var datePicker = UIDatePicker()
    private lazy var stubStackView = UIStackView()
    private let imageView = UIImageView()
    private lazy var filterButton = UIButton()
    private let stubLabel = UILabel(
        text: NSLocalizedString("empty_trackers_stub", comment: "Empty trackers list stub label"),
        textColor: .ypBlack,
        font:.systemFont(ofSize: 12, weight: .medium),
        textAlighment: .center)
        
    private let defaultCategory = NSLocalizedString("default_category", comment: "Default category header")
    private var categories: [TrackerCategory] = []
    private var currentDate: Date = Date()
    
    private var visibleCategories: [TrackerCategory] {
        return categories.compactMap { category in
            guard let weekday = Calendar.weekdayNumber(for: currentDate) else { return nil }
            let filteredResults = category.trackers.filter { $0.schedule.contains(weekday) }
            return filteredResults.isEmpty ? nil : TrackerCategory(header: category.header, trackers: filteredResults)
        }
    }
    
    private let analyticsService = AnalyticsService()
            
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureUI()
        configureLayout()
        configureStartupData()
        updateStubIsHiddenStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.report(event: "didAppearTrackersViewController", params: ["event":"open", "screen":"Main"])
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "didDisappearTrackersViewController", params: ["event":"close", "screen":"Main"])
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCardCell.reuseIdentifier, for: indexPath) as? TrackerCardCell else { return UICollectionViewCell() }
        if let category = visibleCategories[safe: indexPath.section] {
            let tracker = category.trackers[indexPath.row]
                        
            let daysCounter = try? dataProvider?.count(at: tracker.id)
            let isCompleted = try? dataProvider?.isCompleted(for: tracker.id, at: currentDate)
                        
            cell.configure(with: tracker, daysCounter: daysCounter ?? 0, completion: isCompleted ?? false, date: currentDate, at: indexPath)
            cell.delegate = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderView.reuseIdentifier,
            for: indexPath) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        if let category = visibleCategories[safe: indexPath.section] {
            header.setHeader(with: category.header)
        }
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 9) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { [weak self] action in
            return UIMenu(children: [
                UIAction(title: NSLocalizedString("menu_action_edit", comment: "Edit menu action")) { [weak self] _ in
                    guard let self else { return }
                    self.analyticsService.report(event: "didSelectEditTracker", params: ["event":"click", "screen":"Main", "item":"edit"])
                    
                    if let category = self.visibleCategories[safe: indexPath.section],
                       let tracker = category.trackers[safe: indexPath.item] {
                        let daysCounter = try? dataProvider?.count(at: tracker.id)
                        
                        let creationViewController = TrackerCreationViewController()
                        creationViewController.dataProvider = dataProvider
                        creationViewController.edit(tracker, with: category, daysCount: daysCounter ?? 0)
                        creationViewController.onTrackerEdited = { newCategory, oldCategory in
                            guard let tracker = newCategory.trackers.first,
                                  let oldCategory else { return }
                            self.removeTracker(tracker, from: oldCategory)
                            self.updateTracker(tracker, for: newCategory)
                            try? self.dataProvider?.update(tracker, category: newCategory)
                        }
                        creationViewController.modalPresentationStyle = .pageSheet
                        navigationController?.present(creationViewController, animated: true, completion: nil)
                    }
                },
                UIAction(title: NSLocalizedString("menu_action_delete", comment: "Delete menu action"), attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.analyticsService.report(event: "didSelectDeleteTracker", params: ["event":"click", "screen":"Main", "item":"delete"])
                    
                    let deleteAlert = UIAlertController(title: NSLocalizedString("delete_alert_title", comment: "Delete alert title"), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                    let removeAction = UIAlertAction(title: NSLocalizedString("delete_action", comment: "Delete action"), style: .destructive) { _ in
                        if var category = self.visibleCategories[safe: indexPath.section] {
                            var trackers = category.trackers
                            let tracker = trackers.remove(at: indexPath.row)
                                                                                        
                            category = TrackerCategory(header: category.header, trackers: trackers)
                            self.categories = self.categories.map({ $0.header == category.header ? category : $0 })
                            try? self.dataProvider?.delete(tracker)
                        }
                    }

                    let cancelAction = UIAlertAction(title: NSLocalizedString("cancel_action", comment: "Cancel action"), style: .cancel, handler: nil)
                    deleteAlert.addAction(removeAction)
                    deleteAlert.addAction(cancelAction)
                    self.present(deleteAlert, animated: true, completion: nil)
                },
            ])
        })
    }
    
    // MARK: - TrackerCardCellDelegate
    func setCompletionTo(completion: Bool, with id: UUID, at indexPath: IndexPath) {
        analyticsService.report(event: "didTapTrackButton", params: ["event":"click", "screen":"Main", "item":"track"])
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate)
        
        do {
            completion ?
                try dataProvider?.delete(trackerRecord) :
                try dataProvider?.add(trackerRecord)
        } catch {
            showError(NSLocalizedString("save_changes_error", comment: "Save changes error message"))
            return
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - TrackerDataProviderDelegate
    func store(_ store: TrackerDataProvider?, newIndexPath: IndexPath?) {
        collectionView.reloadData()
        updateStubIsHiddenStatus()
    }
    
    // MARK: - Private func
    private func configureUI() {
        // dataProvider
        dataProvider?.delegate = self
        
        // navigationController
        navigationController?.navigationBar.prefersLargeTitles = true
        title = NSLocalizedString("title_trackers", comment: "Trackers title label")
        
        // leftButton
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addTracker))
        leftButton.image = UIImage(named: "AddTracker")
        leftButton.tintColor = .ypBlack
        leftButton.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)

        // rightButton
        let rightButton = UIBarButtonItem(customView: datePicker)
        
        // searchBar
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = NSLocalizedString("search_placeholder", comment: "Search bar placeholder")
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.searchBar.setValue(NSLocalizedString("search_cancellation", comment: "Search cancellation button"), forKey: "cancelButtonText")
        
        // filterButton
        filterButton.setTitle(NSLocalizedString("title_filters", comment: "Filters button title"), for: .normal)
        filterButton.titleLabel?.font = .systemFont(ofSize: 17)
        filterButton.backgroundColor = .ypBlue
        filterButton.layer.cornerRadius = 16
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.searchController = searchBar
        
        // collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCardCell.self, forCellWithReuseIdentifier: TrackerCardCell.reuseIdentifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // datePicker
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector (dateChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // stubStackView
        stubStackView.distribution = .equalCentering
        stubStackView.axis = .vertical
        stubStackView.backgroundColor = .clear
        stubStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "DizzyScreenLogo")
        
        view.backgroundColor = .ypWhite
        
        // hierarchy
        stubStackView.addSubview(imageView)
        stubStackView.addSubview(stubLabel)
        view.addSubview(stubStackView)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            stubStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubStackView.heightAnchor.constraint(equalToConstant: 106),
            
            datePicker.heightAnchor.constraint(equalToConstant: 34),
                        
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stubLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: stubStackView.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: stubStackView.trailingAnchor, constant: -16),
                                                                                    
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func configureStartupData() {
        categories = dataProvider?.categories ?? []
        if !categories.contains(where: { $0.header == defaultCategory }) {
            categories += [TrackerCategory(header: self.defaultCategory, trackers: [])]
        }
    }
    
    private func updateStubIsHiddenStatus() {
        let isHidden = visibleCategories.count > 0 ? true : false
        stubStackView.isHidden = isHidden
    }
    
    private func checkExistingCategory(category: TrackerCategory) -> TrackerCategory? {
        return category.header.isEmpty ?
            categories.first(where: { $0.header == defaultCategory }) :
            categories.first(where: { $0.header == category.header })
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: NSLocalizedString("title_error", comment: "Errro alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("action_ok", comment: "OK alert action"), style: .default, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }
    
    private func add(_ trackerCategory: TrackerCategory) {
        do {
            try self.dataProvider?.add(trackerCategory)
        } catch {
            showError(NSLocalizedString("save_changes_error", comment: "Save changes error message"))
            return
        }
    }
    
    private func removeTracker(_ tracker: Tracker, from previousCategory: TrackerCategory) {
        let tempCategory = self.categories.first(where: { $0.header == previousCategory.header })
        if var trackers = tempCategory?.trackers,
            let tempCategory {
            trackers.removeAll(where: { $0.id == tracker.id })
            let updatedCategory = TrackerCategory(header: tempCategory.header, trackers: trackers)
            self.categories = self.categories.map({ $0.header == updatedCategory.header ? updatedCategory : $0 })
        }
    }
    
    private func updateTracker(_ tracker: Tracker, for newCategory: TrackerCategory) {
        if let existCategory = self.checkExistingCategory(category: newCategory) {
            var trackers = existCategory.trackers
            trackers.removeAll(where: { $0.id == tracker.id })
            trackers.append(tracker)
            let category = TrackerCategory(header: existCategory.header, trackers: trackers)
            self.categories = self.categories.map({ $0.header == category.header ? category : $0 })
        } else {
            let trackers = newCategory.trackers
            let newCategory = TrackerCategory(header: newCategory.header, trackers: trackers)
            self.categories.append(newCategory)
        }
        collectionView.reloadData()
    }
        
    // MARK: - Actions
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        collectionView.reloadData()
        updateStubIsHiddenStatus()
    }
        
    @objc private func addTracker() {
        analyticsService.report(event: "didTapAddTrackerButton", params: ["event":"click", "screen":"Main", "item":"add_track"])
        let creationViewController = TrackerCreationViewController()
        creationViewController.dataProvider = dataProvider
        creationViewController.onTrackerCreated = { category in
            if var oldCategory = self.checkExistingCategory(category: category) {
                let newTrackers = oldCategory.trackers + category.trackers
                oldCategory = TrackerCategory(header: oldCategory.header, trackers: newTrackers)
                self.categories = self.categories.map({ $0.header == oldCategory.header ? oldCategory : $0 })
                self.add(oldCategory)
            } else {
                let trackers = category.trackers
                let newCategory = TrackerCategory(header: category.header, trackers: trackers)
                self.categories.append(newCategory)
                self.add(newCategory)
            }
        }
        creationViewController.modalPresentationStyle = .pageSheet
        navigationController?.present(creationViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapFilterButton() {
        analyticsService.report(event: "didTapFilterButton", params: ["event":"click", "screen":"Main", "item":"filter"])
    }
}

@available(iOS 17.0, *)
#Preview {
    TrackersViewController()
}
