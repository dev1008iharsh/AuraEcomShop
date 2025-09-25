//
//  ProfileTVC.swift
//  AuraEcomShop
//
//  Created by Harsh on 25/09/25.
//

import UIKit

final class ProfileTVC: UITableViewCell {
    
    static let reuseID = "ProfileTVC"
    
    private let imgAvatar: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
 
        iv.image = UIImage(systemName: "person.circle.fill") // system default avatar
        iv.tintColor = .AppTheme.secondary
        iv.backgroundColor = .clear
        return iv
    }()
    
    private let lblName: UILabel = {
        let lbl = UILabel()
        lbl.font = FontHelper.roboto(.bold(18))
        lbl.textColor = .AppTheme.textPrimary
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let lblSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.font = FontHelper.roboto(.regular(14))
        lbl.textColor = .AppTheme.textSecondary
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var stackText: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblName, lblSubtitle])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        backgroundColor = .AppTheme.cellBackground
        contentView.backgroundColor = .AppTheme.cellBackground
        selectionStyle = .none
        contentView.addSubview(imgAvatar)
        contentView.addSubview(stackText)
        
        NSLayoutConstraint.activate([
            imgAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imgAvatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imgAvatar.widthAnchor.constraint(equalToConstant: 60),
            imgAvatar.heightAnchor.constraint(equalToConstant: 60),
            
            stackText.leadingAnchor.constraint(equalTo: imgAvatar.trailingAnchor, constant: 12),
            stackText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
        
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(name: String, subtitle: String, image: UIImage?) {
        lblName.text = name
        lblSubtitle.text = subtitle
        if let image = image { imgAvatar.image = image }
    }
}
