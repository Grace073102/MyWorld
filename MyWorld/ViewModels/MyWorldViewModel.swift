//
//  MyWorldViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 1/10/2026.
//

import Foundation
import Combine

@MainActor
final class MyWorldViewModel: ObservableObject {

    @Published var places: [VisitedPlaceModel] = []
    @Published var errorMessage: String?

    private let getAllVisitedPlacesUseCase: GetAllVisitedPlacesUseCase

    private let repository: TravelRepositoryProtocol


    init(
        getAllVisitedPlacesUseCase: GetAllVisitedPlacesUseCase,
        repository: TravelRepositoryProtocol
    ) {

        self.getAllVisitedPlacesUseCase = getAllVisitedPlacesUseCase
        self.repository = repository
    }


    func loadPlaces() {
        do {
            places =
                try getAllVisitedPlacesUseCase
                    .execute()

            errorMessage = nil

        } catch {
            places = []
            errorMessage = "Unable to load your visited places."
        }
    }
    
    var repositoryForView: TravelRepositoryProtocol {
        repository
    }

    func trip(for place: VisitedPlaceModel) -> TripModel? {
        do {
            return try repository.fetchTrip(id: place.tripID)
        } catch {
            return nil
        }
    }
}
