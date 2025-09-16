//
//  AppIconTVC.swift
//  AuraEcomShop
//
//  Created by Harsh on 16/09/25.
//

import UIKit

final class AppIconTVC: UITableViewCell {

    static let reuseID = "AppIconTVC"

    // MARK: - UI Elements
    private let imgPreview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 56).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return iv
    }()

    private let lblName: UILabel = {
        let lbl = UILabel()
        lbl.font = FontHelper.roboto(.medium(16))
        lbl.textColor = .AppTheme.textPrimary
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let imgCheckBox: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 26).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return iv
    }()

    private let stackMain: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 14
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupTheme()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        stackMain.addArrangedSubview(imgPreview)
        stackMain.addArrangedSubview(lblName)
        stackMain.addArrangedSubview(UIView()) // flexible spacer
        stackMain.addArrangedSubview(imgCheckBox)

        contentView.addSubview(stackMain)

        NSLayoutConstraint.activate([
            stackMain.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    private func setupTheme() {
        backgroundColor = .AppTheme.background
        contentView.backgroundColor = .AppTheme.background

        let selectedBG = UIView()
        selectedBG.backgroundColor = .AppTheme.secondaryBackground
        selectedBackgroundView = selectedBG
    }

    // MARK: - Configure
    func configure(title: String, previewAssetName: String, isSelected: Bool) {
        lblName.text = title

        if let img = UIImage(named: previewAssetName) {
            imgPreview.image = img
        } else {
            imgPreview.image = nil
            imgPreview.backgroundColor = .AppTheme.surface
        }

        let symbolName = isSelected ? "checkmark.circle.fill" : "circle"
        let img = UIImage(systemName: symbolName)
        imgCheckBox.tintColor = isSelected ? .AppTheme.primary : .AppTheme.textSecondary
        imgCheckBox.image = img
    }
}
