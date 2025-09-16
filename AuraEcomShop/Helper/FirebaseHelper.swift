import Foundation
import FirebaseFirestore
import UIKit

final class FirebaseHelper {
    
    static let shared = FirebaseHelper()
    private let db = Firestore.firestore()
    private init() {}
    
    private let imageKitUploadURL = URL(string: "https://upload.imagekit.io/api/v1/files/upload")!
    private let imageKitPrivateKey = "private_xUgDM7FtTdXvdmkihmv7LGRuXLs="
    
    func addCategory(
        name: String,
        slug: String,
        description: String,
        isActive: Bool,
        image: UIImage,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let compressed = ImageCompressor.compress(image: image,
                                                        maxByteSize: 120_000,
                                                        maxDimension: 1024)
        else {
            completion(.failure(NSError(domain: "FirebaseHelper",
                                        code: 2001,
                                        userInfo: [NSLocalizedDescriptionKey: "Image compression failed"])))
            return
        }
        
        uploadToImageKit(imageData: compressed) { [weak self] result in
            switch result {
            case .success(let imageURL):
                self?.saveCategoryDocument(
                    name: name,
                    slug: slug,
                    description: description,
                    isActive: isActive,
                    imageURL: imageURL,
                    completion: completion
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func uploadToImageKit(imageData: Data,
                                  completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: imageKitUploadURL)
        request.httpMethod = "POST"
        
        let authString = "\(imageKitPrivateKey):"
        let authData = authString.data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"category.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"fileName\"\r\n\r\n".data(using: .utf8)!)
        body.append("category.jpg\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"folder\"\r\n\r\n".data(using: .utf8)!)
        body.append("categories/\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"useUniqueFileName\"\r\n\r\n".data(using: .utf8)!)
        body.append("true\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(.failure(NSError(domain: "ImageKit",
                                            code: 2002,
                                            userInfo: [NSLocalizedDescriptionKey: "Invalid ImageKit response"])))
                return
            }
            
            if let url = json["url"] as? String {
                completion(.success(url))
            } else {
                let message = json["message"] as? String ?? "Unexpected ImageKit response"
                completion(.failure(NSError(domain: "ImageKit",
                                            code: 2003,
                                            userInfo: [NSLocalizedDescriptionKey: message])))
            }
        }.resume()
    }
    
    private func saveCategoryDocument(
        name: String,
        slug: String,
        description: String,
        isActive: Bool,
        imageURL: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let categoryId = UUID().uuidString
        let docRef = db.collection("categories").document(categoryId)
        
        let data: [String: Any] = [
            "categoryId": categoryId,
            "name": name,
            "slug": slug,
            "description": description,
            "isActive": isActive,
            "imagePath": imageURL,
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
