//
//  RecordTripUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

struct RecordTripUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        name: String,
        country: String,
        countryCode: String,
        startDate: Date,
        endDate: Date,
        notes: String
    ) throws {

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCountry = country.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            throw TravelError.emptyTripName
        }

        guard !trimmedCountry.isEmpty else {
            throw TravelError.emptyCountry
        }

        guard endDate >= startDate else {
            throw TravelError.invalidDateRange
        }

        let trip = TripModel(
            id: UUID(),
            name: trimmedName,
            country: trimmedCountry,
            countryCode: countryCode.uppercased(),
            startDate: startDate,
            endDate: endDate,
            notes: notes
        )

        try repository.saveTrip(trip)
    }
}
