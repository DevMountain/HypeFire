//
//  Hype.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation
import Firebase

class Hype {
    var body: String
    var timestamp: Date
    var uuid: String
    var authorID: String
    var authorUsername: String
    
    init(body: String, timestamp: Date = Date(), uuid: String = UUID().uuidString, authorID: String = UserController.shared.currentUser?.uuid ?? "", authorUsername: String = UserController.shared.currentUser?.username ?? "") {
        self.body = body
        self.timestamp = timestamp
        self.uuid = uuid
        self.authorID = authorID
        self.authorUsername = authorUsername
    }
    
    convenience init?(document: DocumentSnapshot) {

        guard let body = document["body"] as? String,
            let timeInterval = document["timestamp"] as? Double,
            let authorID = document["authorID"] as? String,
            let authorUsername = document["authorUsername"] as? String else { return nil }
        let timestamp = Date(timeIntervalSince1970: timeInterval)
        
        self.init(body: body, timestamp: timestamp, uuid: document.documentID, authorID: authorID, authorUsername: authorUsername)
    }
}

extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
