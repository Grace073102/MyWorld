//
//  UpdateVisitedPlaceUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 2/10/2026.
//

import Foundation

struct UpdateVisitedPlaceUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        id: UUID,
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

        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let trimmedCity = city.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // MARK: - Validate Name

        guard !trimmedName.isEmpty else {
            throw TravelError.emptyPlaceName
        }


        // MARK: - Validate Date

        guard visitedDate >= tripStartDate,
              visitedDate <= tripEndDate else {

            throw TravelError.visitedDateOutsideTrip
        }


        // MARK: - Updated Model

        let updatedPlace = VisitedPlaceModel(
            id: id,
            name: trimmedName,
            city: trimmedCity,
            latitude: latitude,
            longitude: longitude,
            visitedDate: visitedDate,
            notes: notes,
            tripID: tripID
        )


        // MARK: - Save Update

        try repository.updatePlace(
            updatedPlace
        )
    }
}
