//
//  VisitedPlaceModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

struct VisitedPlaceModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    var city: String
    var latitude: Double
    var longitude: Double
    var visitedDate: Date
    var notes: String
    var tripID: UUID
}
