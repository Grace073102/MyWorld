//
//  UpdateTravelSummaryUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 5/10/2026.
//

import Foundation

struct UpdateTravelSummaryUseCase {
    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute() throws {
        let trips = try repository.fetchTrips()
        let places = try repository.fetchAllPlaces()

        let countryCount = Set(
            trips.map { $0.countryCode.uppercased() }
        ).count

        SharedTravelSummary.save(
            tripCount: trips.count,
            countryCount: countryCount,
            placeCount: places.count
        )
    }
}
