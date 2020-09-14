//
//  HypeController.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation
import Firebase

class HypeController {
    
    static let shared = HypeController()
    
    var hypes: [Hype] = []
    
    let db = Firestore.firestore()
    let hypeCollection = "hypes"
    
    
    func createHype(body: String, completion: @escaping (Result<Hype, HypeError>) -> Void) {
        let newHype = Hype(body: body)
        
        let timeInterval = newHype.timestamp.timeIntervalSince1970
        
        let hypeRef = db.collection(hypeCollection)
        hypeRef.document("\(newHype.uuid)").setData([
            "body": "\(newHype.body)",
            "timestamp": timeInterval,
            "authorID": "\(newHype.authorID)",
            "authorUsername": "\(newHype.authorUsername)"
        ]) { (error) in
            if let error = error {
                print("There was an error creating a new Hype. \n ===> \(error) \n ===> \(error.localizedDescription)")
                return completion(.failure(.fireError(error)))
            } else {
                print("A Hype, with documentID: \(newHype.uuid), has been created.")
                return completion(.success(newHype))
            }
        }
    }
    
    func fetchAllHypes(completion: @escaping (Result<[Hype], HypeError>) -> Void) {
        db.collection(hypeCollection).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error fetching all Hypes. \n ===> \(error) \n ===> \(error.localizedDescription)")
                return completion(.failure(.fireError(error)))
            } else {
                var fetchedHypes: [Hype] = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    guard let newHype = Hype(document: document) else { return completion(.failure(.couldNotUnwrap)) }
                    fetchedHypes.append(newHype)
                }
                let sortedHypes = fetchedHypes.sorted(by: { $0.timestamp > $1.timestamp })
                return completion(.success(sortedHypes))
            }
        }
    }
    
    func updateHype(hype: Hype, completion: @escaping (Result<Hype, HypeError>) -> Void) {
        let docRef = db.collection(hypeCollection).document(hype.uuid)
        docRef.updateData([
            "body": "\(hype.body)"
        ]) { (error) in
            if let error = error {
                print("There was an error updating the Hype. \n ===> \(error) \n ===> \(error.localizedDescription)")
                return completion(.failure(.fireError(error)))
            } else {
                return completion(.success(hype))
            }
        }
    }
    
    func deleteHype(hype: Hype, completion: @escaping (Result<Bool, HypeError>) -> Void) {
        let docRef = db.collection(hypeCollection).document(hype.uuid)
        docRef.delete { (error) in
            if let error = error {
                print("There was an error deleting the Hype. \n ===> \(error) \n ===> \(error.localizedDescription)")
                return completion(.failure(.fireError(error)))
            } else {
                return completion(.success(true))
            }
        }
    }
}
