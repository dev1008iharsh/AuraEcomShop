//
//  FontHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import UIKit

enum FontStyle {
    case regular(CGFloat)
    case medium(CGFloat)
    case bold(CGFloat)
    case light(CGFloat)
}

struct FontHelper {
    static func roboto(_ style: FontStyle) -> UIFont {
        switch style {
        case .regular(let size):
            return UIFont(name: "RobotoSlab-Regular", size: size) ?? .systemFont(ofSize: size)
        case .medium(let size):
            return UIFont(name: "RobotoSlab-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
        case .bold(let size):
            return UIFont(name: "RobotoSlab-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
        case .light(let size):
            return UIFont(name: "RobotoSlab-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
        }
    }
}
