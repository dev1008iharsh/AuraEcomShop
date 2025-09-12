//
//  ButtonHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit

enum ButtonHelper {
    
    /// Create a styled rounded button
    static func makeRoundedButton(title: String,
                                  backgroundColor: UIColor,
                                  textColor: UIColor,
                                  image: UIImage? = nil,
                                  cornerRadius: CGFloat = 12,
                                  fontSize: CGFloat = 16) -> UIButton {
        
        let button = UIButton(type: .system)
        
        // Config with image + title
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = textColor
        config.cornerStyle = .large
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = image == nil ? 0 : 8
        
        // Title with Roboto font
        if let robotoFont = UIFont(name: "Roboto-Regular", size: fontSize) {
            var titleAttr = AttributedString(title)
            titleAttr.font = robotoFont
            config.attributedTitle = titleAttr
        } else {
            config.title = title
        }
        
        button.configuration = config
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = false
        
        // Add shadow for elevation
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        // Default height
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }
}
