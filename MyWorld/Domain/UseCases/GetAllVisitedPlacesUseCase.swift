//
//  GetAllVisitedPlacesUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 1/10/2026.
//

import Foundation

struct GetAllVisitedPlacesUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute() throws -> [VisitedPlaceModel] {
        try repository.fetchAllPlaces()
    }
}
