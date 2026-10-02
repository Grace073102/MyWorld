//
//  RepositoryError.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

enum RepositoryError: Error, LocalizedError {

    case tripNotFound
    case placeNotFound

    var errorDescription: String? {
        switch self {
        case .tripNotFound:
            return "The trip could not be found."

        case .placeNotFound:
            return "The place could not be found."
        }
    }
}
