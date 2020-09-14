//
//  UserController.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    static let shared = UserController()
    var currentUser: User?
    let db = Firestore.firestore()
    let userCollection = "users"
    
    func createAndSaveUser(username: String, password: String, profilePhoto: UIImage?, completion: @escaping (Result<User, UserError>) -> Void) {
        let newUser = User(username: username, password: password, profilePhoto: profilePhoto)
        
        let usersRef = db.collection(userCollection)
        usersRef.document("\(newUser.uuid)").setData([
            "username": "\(newUser.username)",
            "password": "\(newUser.password)",
            "profilePhoto": newUser.profilePhoto?.jpegData(compressionQuality: 1)
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                print("Document added with ID: \(newUser.uuid)")
                return completion(.success(newUser))
            }
        }
    }
    
    func fetchUser(username: String, password: String, completion: @escaping (Result<User, UserError>) -> Void) {
        let usersRef = db.collection(userCollection)
        
        usersRef.whereField("username", isEqualTo: username).whereField("password", isEqualTo: password).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("UHHH there was an error getting users with a username: \(username). - \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                guard let doc = querySnapshot!.documents.first,
                    let fetchedUser = User(document: doc) else {
                    return completion(.failure(.couldNotUnwrap))
                }
                return completion(.success(fetchedUser))
            }
        }
    }
    
    func fetchUserProfileImage(authorID: String, completion: @escaping (Result<UIImage?, UserError>) -> Void) {
        let usersRef = db.collection(userCollection).document(authorID)
        usersRef.getDocument { (docSnapshot, error) in
            if let error = error {
                print("UHHH there was an error getting the user. ==> \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                guard let document = docSnapshot,
                    let user = User(document: document) else {return completion(.failure(.couldNotUnwrap))}
                let profileImage = user.profilePhoto
                return completion(.success(profileImage))
            }
        }
    }
}
