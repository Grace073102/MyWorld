//
//  SharedTravelSummary.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 5/10/2026.
//

import Foundation

struct SharedTravelSummary {
    static let appGroup = "group.com.gracechong.MyWorld"

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroup)
    }

    static func save(tripCount: Int, countryCount: Int, placeCount: Int) {
        defaults?.set(tripCount, forKey: "tripCount")
        defaults?.set(countryCount, forKey: "countryCount")
        defaults?.set(placeCount, forKey: "placeCount")
    }
}
