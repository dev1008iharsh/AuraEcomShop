//
//  ChangeAppIconVC.swift
//  AuraEcomShop
//
//  Created by Harsh on 16/09/25.
//

import UIKit

final class ChangeAppIconVC: UIViewController {

    // Default icon + 10 alternates
    private let appIconKeys: [String] = [
        "AppIcon", // Default
        "icon1", "icon2", "icon3", "icon4", "icon5",
        "icon6", "icon7", "icon8", "icon9", "icon10"
    ]

    private let tblAppIcons: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .AppTheme.background
        return tv
    }()

    private var selectedKey: String {
        return UIApplication.shared.alternateIconName ?? "AppIcon"
    }

    /// Returns the set of alternate icon keys declared in Info.plist (CFBundleAlternateIcons)
    private func declaredAlternateIconKeys() -> Set<String> {
        guard
            let bundleIcons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
            let alternate = bundleIcons["CFBundleAlternateIcons"] as? [String: Any]
        else { return [] }
        return Set(alternate.keys)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App Icons"
        view.backgroundColor = .AppTheme.background
        setupTable()
        setupNavBar()
        
        if !UIApplication.shared.supportsAlternateIcons {
            #if DEBUG
            print("[AppIcon] Alternate icons not supported on this device or OS.")
            #endif
        }
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(didTapResetToDefault)
        )
    }

    @objc private func didTapResetToDefault() {
        guard UIApplication.shared.supportsAlternateIcons else {
            AlertHelper.showOK(on: self,
                               title: "Not Supported",
                               message: "This device does not support alternate app icons.")
            return
        }

        AlertHelper.showConfirm(on: self,
                                title: "Reset App Icon",
                                message: "Do you want to reset to the default app icon?",
                                confirmTitle: "Reset") { [weak self] in
            self?.setAppIcon(named: nil)
        }
    }

    private func setupTable() {
        view.addSubview(tblAppIcons)
        tblAppIcons.delegate = self
        tblAppIcons.dataSource = self
        tblAppIcons.register(AppIconTVC.self, forCellReuseIdentifier: AppIconTVC.reuseID)

        NSLayoutConstraint.activate([
            tblAppIcons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tblAppIcons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tblAppIcons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tblAppIcons.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Change icon
    @available(iOS 10.3, *)
    private func setAppIcon(named iconName: String?) {
        // Check if alternate icons are supported
        guard UIApplication.shared.supportsAlternateIcons else {
            AlertHelper.showOK(
                on: self,
                title: "Not Supported",
                message: "This device does not support alternate app icons."
            )
            return
        }

        #if DEBUG
        print("[AppIcon] Attempting to set icon to: \(iconName ?? "AppIcon")")
        #endif

        let current = UIApplication.shared.alternateIconName ?? "AppIcon"
        let target = iconName ?? "AppIcon"

        // Avoid redundant changes
        guard current != target else { return }

        if let name = iconName {
            let declared = declaredAlternateIconKeys()
            if !declared.contains(name) {
                AlertHelper.showOK(
                    on: self,
                    title: "Icon Not Configured",
                    message: "The alternate icon '\(name)' is not declared in Info.plist under CFBundleAlternateIcons."
                )
                return
            }
        }

        UIApplication.shared.setAlternateIconName(iconName) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    AlertHelper.showOK(
                        on: self,
                        title: "Failed to Change Icon",
                        message: error.localizedDescription
                    )
                } else {
                    #if DEBUG
                    print("[AppIcon] Icon changed successfully to: \(iconName ?? "AppIcon")")
                    #endif
                    // ✅ silently update UI (no success alert)
                    self.tblAppIcons.reloadData()
                }
            }
        }
    }
}

// MARK: - Table Delegate / Data Source
extension ChangeAppIconVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appIconKeys.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AppIconTVC.reuseID,
            for: indexPath
        ) as? AppIconTVC else {
            return UITableViewCell()
        }

        let key = appIconKeys[indexPath.row]
        let title = (key == "AppIcon") ? "Default" : "Icon \(indexPath.row)"
        let previewAssetName = "\(key)_preview"
        let isSelected = (selectedKey == key)

        cell.configure(title: title,
                       previewAssetName: previewAssetName,
                       isSelected: isSelected)
        
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = appIconKeys[indexPath.row]
        let title = (key == "AppIcon") ? "Default" : "Icon \(indexPath.row)"
        let message = "Do you want to change the app icon to '\(title)'?"

        AlertHelper.showConfirm(on: self,
                                title: "Change App Icon",
                                message: message,
                                confirmTitle: "Change") { [weak self] in
            guard let self = self else { return }
            let iconNameToSet: String? = (key == "AppIcon") ? nil : key
            self.setAppIcon(named: iconNameToSet)
        }
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}

