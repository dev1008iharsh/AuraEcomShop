import UIKit
import FirebaseFirestore
struct Category: Codable, Identifiable {
    @DocumentID var id: String?
    var categoryId: String
    var name: String
    var slug: String
    var description: String
    var isActive: Bool
    var imageBase64: String
    var createdAt: Date?
    
    var image: UIImage? {
        if let data = Data(base64Encoded: imageBase64) {
            return UIImage(data: data)
        }
        return nil
    }
}
