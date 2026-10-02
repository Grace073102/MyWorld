//
//  TravelError.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

enum TravelError: Error, Equatable, LocalizedError {
    case emptyTripName
    case emptyCountry
    case invalidDateRange
    case emptyPlaceName
    case visitedDateOutsideTrip

    var errorDescription: String? {
        switch self {
        case .emptyTripName:
            return "Please enter a name for your trip."

        case .emptyCountry:
            return "Please select a country for your trip."

        case .invalidDateRange:
            return "The trip end date cannot be earlier than the start date."

        case .emptyPlaceName:
            return "Please enter a name for the visited place."
            
        case .visitedDateOutsideTrip:
            return "The visited date must be between the trip start and end dates."
        }
    }
}
