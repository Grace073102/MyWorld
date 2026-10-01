//
//  TripDetailViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 1/10/2026.
//

import Foundation
import Combine

@MainActor
final class TripDetailViewModel: ObservableObject {

    @Published var places: [VisitedPlaceModel] = []
    @Published var errorMessage: String?

    private let tripID: UUID
    private let getPlacesForTripUseCase: GetPlacesForTripUseCase

    init(
        tripID: UUID,
        getPlacesForTripUseCase: GetPlacesForTripUseCase
    ) {
        self.tripID = tripID
        self.getPlacesForTripUseCase = getPlacesForTripUseCase
    }

    func loadPlaces() {
        do {
            places = try getPlacesForTripUseCase.execute(tripID: tripID)
            errorMessage = nil
        } catch {
            errorMessage = "Unable to load visited places."
        }
    }
}
