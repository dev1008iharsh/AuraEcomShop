//
//  FirebaseHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 13/09/25.
//

import Foundation
import FirebaseFirestore
import UIKit

final class FirebaseHelper {
    static let shared = FirebaseHelper()
    private let db = Firestore.firestore()
    private init() {}
    
    func addCategoryWithInlineImage(
        name: String,
        slug: String,
        description: String,
        isActive: Bool,
        image: UIImage,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let categoryId = UUID().uuidString
        let docRef = db.collection("categories").document(categoryId)
        
        // Compress image aggressively
        guard let compressed = ImageCompressor.compress(
            image: image,
            maxByteSize: 120_000,   // ~120 KB target
            maxDimension: 1024,
            preferHEIC: true
        ) else {
            completion(.failure(NSError(domain: "FirebaseHelper",
                                        code: 2001,
                                        userInfo: [NSLocalizedDescriptionKey: "Compression failed"])))
            return
        }
        
        let base64String = compressed.base64EncodedString()
        
        let data: [String: Any] = [
            "categoryId": categoryId,
            "name": name,
            "slug": slug,
            "description": description,
            "isActive": isActive,
            "imageBase64": base64String,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        docRef.setData(data) { error in
            if let error = error { completion(.failure(error)) }
            else { completion(.success(())) }
        }
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        db.collection("categories")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let categories: [Category] = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Category.self)
                } ?? []
                completion(.success(categories))
            }
    }
}
