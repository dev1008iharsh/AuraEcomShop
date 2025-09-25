//
//  SettingVC.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit

import UIKit

final class SettingsVC: UIViewController {
    
    // MARK: - Properties
    private var tblSettings: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearching: Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    // Data source
    private let accountItems = [
        ("Orders", "cart"),
        ("Saved Addresses", "house"),
        ("Saved Payment Methods", "creditcard"),
        ("Wishlist", "heart"),
        ("Recently Viewed Items", "clock"),
        ("Rewards", "gift")
    ]
    
    private let preferenceItems = [
        ("App Customization", "paintpalette"),
        ("Notification Preferences", "bell"),
        ("Support", "questionmark.circle"),
        ("Interested Categories", "tag"),
        ("Language & Region", "globe")
    ]
    
    private let managementItems = [
        ("Data & Privacy", "lock.shield"),
        ("Clear Cache", "arrow.clockwise"),
        ("Delete Account", "trash"),
        ("Logout", "rectangle.portrait.and.arrow.right")
    ]
    
    private var filteredSections: [[(String, String)]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        setupTable()
        setupSearch()
    }
    
    // MARK: - Setup
    private func setupTable() {
        tblSettings = UITableView(frame: view.bounds, style: .insetGrouped)
        tblSettings.backgroundColor = .systemGray5 // ✅ gray outside
        tblSettings.separatorColor = .AppTheme.background
        tblSettings.delegate = self
        tblSettings.dataSource = self
        view.addSubview(tblSettings)

        tblSettings.register(ProfileTVC.self, forCellReuseIdentifier: ProfileTVC.reuseID)
        tblSettings.register(SettingsItemTVC.self, forCellReuseIdentifier: SettingsItemTVC.reuseID)
    }
    
    private func setupSearch() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Profile + 3 categories
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90 // 👈 bigger profile cell
        }
        return 50 // 👈 default row height for other cells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        
        let items: [(String, String)]
        switch section {
        case 1: items = isSearching ? filteredSections[0] : accountItems
        case 2: items = isSearching ? filteredSections[1] : preferenceItems
        case 3: items = isSearching ? filteredSections[2] : managementItems
        default: items = []
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTVC.reuseID, for: indexPath) as! ProfileTVC
            cell.configure(
                name: "Harsh Patel",
                subtitle: "Apple Account, Rewards, etc.",
                image: UIImage(named: "DefaultProfile")
            )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemTVC.reuseID, for: indexPath) as! SettingsItemTVC
            
            let items: [(String, String)]
            switch indexPath.section {
            case 1: items = isSearching ? filteredSections[0] : accountItems
            case 2: items = isSearching ? filteredSections[1] : preferenceItems
            case 3: items = isSearching ? filteredSections[2] : managementItems
            default: items = []
            }
            
            let item = items[indexPath.row]
            let bgColor: UIColor
            switch item.0 {
            case "Orders": bgColor = .systemBlue
            case "Saved Addresses": bgColor = .systemGreen
            case "Saved Payment Methods": bgColor = .systemOrange
            case "Wishlist": bgColor = .systemPink
            case "Recently Viewed Items": bgColor = .systemPurple
            case "Rewards": bgColor = .systemYellow
            case "App Customization": bgColor = .systemTeal
            case "Notification Preferences": bgColor = .systemRed
            case "Support": bgColor = .systemGray
            case "Interested Categories": bgColor = .systemIndigo
            case "Language & Region": bgColor = .systemBlue
            case "Data & Privacy": bgColor = .systemGray2
            case "Clear Cache": bgColor = .systemGray3
            case "Delete Account": bgColor = .systemGray
            case "Logout": bgColor = .systemRed
            default: bgColor = .AppTheme.primary
            }
            
            cell.configure(
                title: item.0,
                iconSystemName: item.1,
                bgColor: bgColor,
                textColor: (item.0 == "Delete Account" || item.0 == "Logout") ? .AppTheme.error : nil
            )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("Tapped: Section \(indexPath.section), Row \(indexPath.row)")
    }
}

// MARK: - UISearchResultsUpdating
extension SettingsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        
        if searchText.isEmpty {
            filteredSections = []
        } else {
            filteredSections = [
                accountItems.filter { $0.0.lowercased().contains(searchText) },
                preferenceItems.filter { $0.0.lowercased().contains(searchText) },
                managementItems.filter { $0.0.lowercased().contains(searchText) }
            ]
        }
        tblSettings.reloadData()
    }
}
