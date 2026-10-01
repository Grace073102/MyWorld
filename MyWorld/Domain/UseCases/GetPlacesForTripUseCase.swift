//
//  GetPlacesForTripUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 1/10/2026.
//

import Foundation

struct GetPlacesForTripUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(tripID: UUID) throws -> [VisitedPlaceModel] {
        try repository.fetchPlaces(tripID: tripID)
    }
}
