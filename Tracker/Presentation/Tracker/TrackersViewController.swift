//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 08.09.2025.
//

import UIKit
import Foundation

final class TrackersViewController: UIViewController {
    
    private let addButton =
        UIButton.createCustomButton(withImage: "Add")
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "en-US")
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let headerLabel: UILabel = {
        return UILabel(
        text: "Трекеры",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 34, weight: .bold))
    }()
    
    private let searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }()
        
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "DizzyScreenLogo")
        return imageView
    }()
    
    private let stubLabel: UILabel = {
        return UILabel(
        text: "Что будем отслеживать ?",
        textColor: .ypBlack,
        font:.systemFont(ofSize: 12, weight: .medium),
        textAlighment: .center)
    }()
                    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stubStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
             
        configureLayout()
    }
        
    private func configureLayout() {
        headerStackView.addSubview(addButton)
        headerStackView.addSubview(datePicker)
        
        searchStackView.addSubview(headerLabel)
        searchStackView.addSubview(searchField)
        
        stubStackView.addSubview(imageView)
        stubStackView.addSubview(stubLabel)
        
        view.addSubview(headerStackView)
        view.addSubview(searchStackView)
        view.addSubview(stubStackView)
                
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerStackView.heightAnchor.constraint(equalToConstant: 42),
            
            searchStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 1),
            searchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchStackView.heightAnchor.constraint(equalToConstant: 84),
            
            stubStackView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 230),
            stubStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stubStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stubStackView.heightAnchor.constraint(equalToConstant: 106),
            
            addButton.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            datePicker.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: headerStackView.topAnchor, constant: 4),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            headerLabel.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor, constant: 16),
            headerLabel.widthAnchor.constraint(equalToConstant: 254),
            headerLabel.heightAnchor.constraint(equalToConstant: 41),
                                    
            searchField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stubLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stubLabel.leadingAnchor.constraint(equalTo: stubStackView.leadingAnchor, constant: 16),
            stubLabel.trailingAnchor.constraint(equalTo: stubStackView.trailingAnchor, constant: -16)
        ])
                                    
        view.backgroundColor = .ypWhite
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TrackersViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(UIViewController.devices, id: \.self) { deviceName in
            TrackersViewController().toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
