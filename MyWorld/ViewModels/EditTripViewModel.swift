//
//  EditTripViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 30/9/2026.
//

import Foundation
import Combine

@MainActor
final class EditTripViewModel: ObservableObject {

    @Published var name: String
    @Published var country: String
    @Published var countryCode: String
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var notes: String

    @Published var errorMessage: String?
    @Published var didSave = false

    private let tripID: UUID
    private let updateTripUseCase: UpdateTripUseCase
    
    var updatedTrip: TripModel {
        TripModel(
            id: tripID,
            name: name,
            country: country,
            countryCode: countryCode,
            startDate: startDate,
            endDate: endDate,
            notes: notes
        )
    }

    init(trip: TripModel, updateTripUseCase: UpdateTripUseCase) {
        self.tripID = trip.id
        self.name = trip.name
        self.country = trip.country
        self.countryCode = trip.countryCode
        self.startDate = trip.startDate
        self.endDate = trip.endDate
        self.notes = trip.notes

        self.updateTripUseCase = updateTripUseCase
    }

    func updateTrip() {
        do {
            try updateTripUseCase.execute(
                id: tripID,
                name: name,
                country: country,
                countryCode: countryCode,
                startDate: startDate,
                endDate: endDate,
                notes: notes
            )

            errorMessage = nil
            didSave = true

        } catch {
            errorMessage = error.localizedDescription
            didSave = false
        }
    }
}
