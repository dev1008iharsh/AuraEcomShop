//
//  SettingsItemTVC.swift
//  AuraEcomShop
//
//  Created by Harsh on 25/09/25.
//

import UIKit

final class SettingsItemTVC: UITableViewCell {
    
    static let reuseID = "SettingsItemTVC"
    
    // MARK: - UI
    private let viewIconBackground: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    private let imgIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = FontHelper.roboto(.regular(16))
        lbl.textColor = .AppTheme.textPrimary
        return lbl
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        backgroundColor = .AppTheme.cellBackground
        contentView.backgroundColor = .AppTheme.cellBackground
        selectionStyle = .none
        contentView.addSubview(viewIconBackground)
        viewIconBackground.addSubview(imgIcon)
        contentView.addSubview(lblTitle)
        
        NSLayoutConstraint.activate([
            viewIconBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewIconBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewIconBackground.widthAnchor.constraint(equalToConstant: 32),
            viewIconBackground.heightAnchor.constraint(equalToConstant: 32),
            
            imgIcon.centerXAnchor.constraint(equalTo: viewIconBackground.centerXAnchor),
            imgIcon.centerYAnchor.constraint(equalTo: viewIconBackground.centerYAnchor),
            imgIcon.widthAnchor.constraint(equalToConstant: 18),
            imgIcon.heightAnchor.constraint(equalToConstant: 18),
            
            lblTitle.leadingAnchor.constraint(equalTo: viewIconBackground.trailingAnchor, constant: 12),
            lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblTitle.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -36)
        ])
    
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Configure
    func configure(title: String, iconSystemName: String, bgColor: UIColor, textColor: UIColor? = nil) {
        lblTitle.text = title
        imgIcon.image = UIImage(systemName: iconSystemName)
        viewIconBackground.backgroundColor = bgColor
        if let textColor = textColor {
            lblTitle.textColor = textColor
        } else {
            lblTitle.textColor = .AppTheme.textPrimary
        }
    }
}
