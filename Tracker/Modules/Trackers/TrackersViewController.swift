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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var datePicker = UIDatePicker()
    private lazy var stubStackView = UIStackView()
    private let imageView = UIImageView ()
    private let stubLabel = UILabel(
        text: "Что будем отслеживать ?",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 12, weight: .medium),
        textAlighment: .center)
        
    private let defaultCategory = "Без категории"
    private var categories: [TrackerCategory] = []
    private var currentDate: Date = Date()
    
    var visibleCategories: [TrackerCategory] {
        return categories.compactMap { category in
            guard let weekday = Calendar.weekdayNumber(for: currentDate) else { return nil }
            let filteredResults = category.trackers.filter { $0.schedule.contains(weekday) }
            return filteredResults.isEmpty ? nil : TrackerCategory(header: category.header, trackers: filteredResults)
        }
    }
    
    private lazy var dataProvider: TrackerDataProviderProtocol? = {
        let categoryStore = TrackerCategoryStore()
        let trackerStore = TrackerStore()
        let recordStore = TrackerRecordStore()
        let dataProvider = try? TrackerDataProvider(categoryStore, trackerStore, recordStore, delegate: self)
        return dataProvider
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureUI()
        configureLayout()
        configureStartupData()
        updateStubIsHiddenStatus()
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
                        
            let daysCounter = dataProvider?.count(at: tracker.id)
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
        
    // MARK: - TrackerCardCellDelegate
    func setCompletionTo(completion: Bool, with id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate)
        
        do {
            completion ?
                try dataProvider?.delete(trackerRecord) :
                try dataProvider?.add(trackerRecord)
        } catch {
            showError("Не удалось сохранить изменения!")
            return
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - TrackerDataProviderDelegate
    func store(_ store: TrackerDataProvider?, newIndexPath: IndexPath?) {
        collectionView.reloadData()
        self.updateStubIsHiddenStatus()
    }
    
    // MARK: - Private func
    private func configureUI() {
        // navigationController
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Трекеры"
        
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
        searchBar.searchBar.placeholder = "Поиск"
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        
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
            stubLabel.trailingAnchor.constraint(equalTo: stubStackView.trailingAnchor, constant: -16)
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
        let alert = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }
        
    // MARK: - Actions
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        collectionView.reloadData()
        updateStubIsHiddenStatus()
    }
        
    @objc private func addTracker() {
        let creationViewController = TrackerCreationViewController()
        creationViewController.onTrackerCreated = { category in
            if var oldCategory = self.checkExistingCategory(category: category) {
                let newTrackers = oldCategory.trackers + category.trackers
                oldCategory = TrackerCategory(header: oldCategory.header, trackers: newTrackers)
                self.categories = self.categories.map({ $0.header == oldCategory.header ? oldCategory : $0 })
                try? self.dataProvider?.add(oldCategory)
            } else {
                let trackers = category.trackers
                let newCategory = TrackerCategory(header: category.header, trackers: trackers)
                self.categories.append(newCategory)
                try? self.dataProvider?.add(newCategory)
            }
        }
        creationViewController.modalPresentationStyle = .pageSheet
        navigationController?.present(creationViewController, animated: true, completion: nil)
    }
}

@available(iOS 17.0, *)
#Preview {
    TrackerCreationViewController()
}
