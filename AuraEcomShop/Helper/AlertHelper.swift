//
//  AlertHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 16/09/25.
//

import UIKit

final class AlertHelper {
    static func showOK(on vc: UIViewController,
                       title: String?,
                       message: String?,
                       okTitle: String = "OK",
                       completion: (() -> Void)? = nil) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: okTitle, style: .default) { _ in completion?() })
        vc.present(a, animated: true)
    }

    static func showConfirm(on vc: UIViewController,
                            title: String?,
                            message: String?,
                            confirmTitle: String = "Change",
                            cancelTitle: String = "Cancel",
                            confirmStyle: UIAlertAction.Style = .destructive,
                            onConfirm: @escaping () -> Void) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        a.addAction(UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in onConfirm() })
        vc.present(a, animated: true)
    }

    static func showSettingsNeeded(on vc: UIViewController,
                                   title: String = "Permission Needed",
                                   message: String,
                                   openSettingsTitle: String = "Open Settings") {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        a.addAction(UIAlertAction(title: openSettingsTitle, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        vc.present(a, animated: true)
    }
}
