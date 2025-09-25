 
//
//  UserModel.swift
//  AuraEcomShop
//
//  Created by Harsh on 26/09/25.
//

import Foundation
import FirebaseFirestore

struct UserModel: Codable {
    @DocumentID var userId: String?     // Auto-linked to Firestore doc ID
    
    var name: String
    var email: String
    var phone: String?
    var profileImageURL: String?
    
    var defaultAddressId: String?
    var wishlistIds: [String]?
    var recentlyViewed: [String]?
    var coupons: [String]?              // ✅ reward coupon codes
    
    var createdAt: Date?
    var updatedAt: Date?
    
    // MARK: - Firestore dictionary
    func toDict() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "phone": phone ?? "",
            "profileImageURL": profileImageURL ?? "",
            "defaultAddressId": defaultAddressId ?? "",
            "wishlistIds": wishlistIds ?? [],
            "recentlyViewed": recentlyViewed ?? [],
            "coupons": coupons ?? [],
            "createdAt": createdAt ?? Date(),
            "updatedAt": updatedAt ?? Date()
        ]
    }
}
