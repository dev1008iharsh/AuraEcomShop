//
//  FirebaseAuthHelper.swift
//  AuraEcomShop
//
//  Created by Harsh on 26/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthHelper {
    
    static let shared = FirebaseAuthHelper()
    private let db = Firestore.firestore()
    
    private init() {}
     
    // MARK: - Signup
    func signupUser(name: String,
                    email: String,
                    phone: String?,
                    password: String,
                    completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid, let self = self else {
                completion(.failure(NSError(domain: "FirebaseAuthHelper",
                                            code: 500,
                                            userInfo: [NSLocalizedDescriptionKey: "Failed to get UID"])))
                return
            }
            
            let user = UserModel(
                userId: uid,
                name: name,
                email: email,
                phone: phone,
                profileImageURL: nil,
                defaultAddressId: nil,
                wishlistIds: [],
                recentlyViewed: [],
                coupons: [],
                createdAt: Date(),
                updatedAt: Date()
            )
            
            self.db.collection("users").document(uid).setData(user.toDict()) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(user))
                }
            }
        }
    }
    
    // MARK: - Login
    func loginUser(email: String,
                   password: String,
                   completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.failure(NSError(domain: "FirebaseAuthHelper",
                                            code: 500,
                                            userInfo: [NSLocalizedDescriptionKey: "Failed to get UID"])))
                return
            }
            
            self?.fetchUser(by: uid, completion: completion)
        }
    }
    
    // MARK: - Forgot Password
    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Logout
    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Current User (UID)
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    // MARK: - Current User (Full Model)
    func getCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let uid = getCurrentUserId() else {
            completion(.failure(NSError(domain: "FirebaseAuthHelper",
                                        code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "No logged in user"])))
            return
        }
        fetchUser(by: uid, completion: completion)
    }
    
    // MARK: - Private helper
    
    private func fetchUser(by uid: String,
                           completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let user = try snapshot?.data(as: UserModel.self) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "FirebaseAuthHelper",
                                                code: 404,
                                                userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
