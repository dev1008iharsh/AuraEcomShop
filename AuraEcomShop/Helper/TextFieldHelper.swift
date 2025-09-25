//
//  TextFieldHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 25/09/25.
//
import UIKit

enum TextFieldHelper {
    
    /// Create a consistent styled text field
    static func makeTextField(placeholder: String,
                              keyboardType: UIKeyboardType = .default,
                              isSecure: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = FontHelper.roboto(.regular(16))
        tf.textColor = .AppTheme.textPrimary
        tf.backgroundColor = .AppTheme.secondaryBackground
        tf.keyboardType = keyboardType
        tf.isSecureTextEntry = isSecure
        
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.AppTheme.separator.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 50)) // padding
        tf.leftViewMode = .always
        
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
}
