//
//  UIViewController+Extension.swift
//  AuraEcomShop
//
//  Created by Harsh on 12/09/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String = "Info", message: String, okTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showConfirmationAlert(title: String = "Confirm",
                               message: String,
                               okTitle: String = "Yes",
                               cancelTitle: String = "Cancel",
                               onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: okTitle, style: .destructive, handler: { _ in
            onConfirm()
        }))
        present(alert, animated: true)
    }
}
