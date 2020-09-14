//
//  UserError.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/11/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation

enum UserError: LocalizedError {
    case fireError(Error)
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        case .fireError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "We were unable to get a User from the data found."
        }
    }
}
