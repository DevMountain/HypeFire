//
//  User.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation
import Firebase

class User {
    var username: String
    var password: String
    var profilePhoto: UIImage? {
        get {
            guard let data = profilePhotoData else {return nil}
            return UIImage(data: data)
        } set {
            profilePhotoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var profilePhotoData: Data?
    var uuid: String
    
    init(username: String, password: String, profilePhoto: UIImage? = nil, uuid: String = UUID().uuidString) {
        self.username = username
        self.password = password
        self.uuid = uuid
        self.profilePhoto = profilePhoto
    }
    
    convenience init?(document: DocumentSnapshot) {

        guard let username = document["username"] as? String,
            let password = document["password"] as? String else { return nil }
        
        var profilePhoto: UIImage?
        
        if let profilePhotoData = document["profilePhoto"] as? Data {
            profilePhoto = UIImage(data: profilePhotoData)
        }
        
        self.init(username: username, password: password, profilePhoto: profilePhoto, uuid: document.documentID)
    }
}


