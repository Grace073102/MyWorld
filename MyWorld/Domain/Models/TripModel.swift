//
//  TripModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

struct TripModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    var country: String
    var countryCode: String
    var startDate: Date
    var endDate: Date
    var notes: String
}
