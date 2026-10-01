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

    private let getAllVisitedPlacesUseCase:
        GetAllVisitedPlacesUseCase

    init(
        getAllVisitedPlacesUseCase:
            GetAllVisitedPlacesUseCase
    ) {
        self.getAllVisitedPlacesUseCase =
            getAllVisitedPlacesUseCase
    }

    func loadPlaces() {

        do {
            places =
                try getAllVisitedPlacesUseCase.execute()

            errorMessage = nil

        } catch {
            places = []

            errorMessage =
                "Unable to load your visited places."
        }
    }
}
