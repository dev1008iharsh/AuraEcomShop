//
//  ButtonHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit


import UIKit

enum ButtonStyle {
    case primary
    case success
    case warning
    case error
    case disabled
}

final class ButtonHelper {
    
    /// Creates a themed rounded button with optional icon
    static func makeButton(title: String,
                           style: ButtonStyle = .primary,
                           systemImageName: String? = nil,
                           font: UIFont = FontHelper.roboto(.medium(16)),
                           height: CGFloat = 50,
                           cornerRadius: CGFloat = 10,
                           addShadow: Bool = true) -> UIButton {
        
        var config = UIButton.Configuration.filled()
        config.title = title
        
        // Icon
        if let icon = systemImageName {
            config.image = UIImage(systemName: icon)
            config.imagePlacement = .leading
            config.imagePadding = 8
        }
        
        // 🎨 Theme color handling
        switch style {
        case .primary:
            config.baseBackgroundColor = .AppTheme.primary
            config.baseForegroundColor = .white
        case .success:
            config.baseBackgroundColor = .AppTheme.success
            config.baseForegroundColor = .white
        case .warning:
            config.baseBackgroundColor = .AppTheme.warning
            config.baseForegroundColor = .white
        case .error:
            config.baseBackgroundColor = .AppTheme.error
            config.baseForegroundColor = .white
        case .disabled:
            config.baseBackgroundColor = .AppTheme.disabled
            config.baseForegroundColor = .white
        }
        
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = cornerRadius
        button.titleLabel?.font = font
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        // Shadow for elevation
        if addShadow {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.12
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowRadius = 4
            button.layer.masksToBounds = false
        }
        
        // Disabled handling
        if style == .disabled {
            button.isEnabled = false
        }
        
        return button
    }
}
