//
//  HypeError.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation

enum HypeError: LocalizedError {
    case fireError(Error)
    case couldNotUnwrap
    case unableToDeleteRecord
    case noUserLoggedIn
    
    var errorDescription: String {
        switch self {
        case .fireError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Hype... That's not very Hype..."
        case .unableToDeleteRecord:
            return "Unable to delete Hype record from the cloud."
        case .noUserLoggedIn:
            return "There is no user currently logged in."
        }
    }
}
