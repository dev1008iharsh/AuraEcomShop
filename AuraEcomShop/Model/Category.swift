import UIKit
import SDWebImage

import Foundation
import FirebaseFirestore

struct Category: Codable {
    @DocumentID var id: String?   // Firestore document ID
    
    let categoryId: String
    let name: String
    let slug: String
    let description: String
    let isActive: Bool
    let imagePath: String
    let createdAt: Date?
}
