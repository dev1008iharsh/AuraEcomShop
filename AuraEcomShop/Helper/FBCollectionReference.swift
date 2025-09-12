//
//  FBCollectionReference.swift
//  AuraEcomShop
//
//  Created by Harsh on 12/09/25.
//
 
import FirebaseFirestore

enum FBCollectionReference: String {
    case user = "User"
    case category = "Category"
    case items = "Items"
    case basket = "Basket"
}

func firebaseReference(_ collectionReference: FBCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(collectionReference.rawValue)
}
