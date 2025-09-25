//
//  ValidationHelper.swift
//  AuraEcomShop
//

import Foundation

final class ValidationHelper {
    
    static func isValidName(_ name: String) -> Bool {
        return name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        // lowercase only
        let lowercased = email.lowercased()
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: lowercased)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        // At least 8 chars, one uppercase, one lowercase, one digit
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    static func isValidPhone(_ phone: String) -> Bool {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count == 10 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: trimmed))
    }
}
