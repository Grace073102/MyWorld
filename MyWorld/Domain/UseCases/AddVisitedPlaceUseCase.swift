//
//  AddVisitedPlaceUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

struct AddVisitedPlaceUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        tripID: UUID,
        name: String,
        city: String,
        latitude: Double,
        longitude: Double,
        visitedDate: Date,
        tripStartDate: Date,
        tripEndDate: Date,
        notes: String
    ) throws {

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            throw TravelError.emptyPlaceName
        }

        // Visited date must be within trip dates
        guard visitedDate >= tripStartDate && visitedDate <= tripEndDate else {
            throw TravelError.visitedDateOutsideTrip
        }

        let place = VisitedPlaceModel(
            id: UUID(),
            name: trimmedName,
            city: trimmedCity,
            latitude: latitude,
            longitude: longitude,
            visitedDate: visitedDate,
            notes: notes,
            tripID: tripID
        )

        try repository.savePlace(place)
    }
}
