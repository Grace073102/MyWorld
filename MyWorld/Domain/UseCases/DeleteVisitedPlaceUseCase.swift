//
//  DeleteVisitedPlaceUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 2/10/2026.
//

import Foundation

struct DeleteVisitedPlaceUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(placeID: UUID) throws {
        try repository.deletePlace(id: placeID)
    }
}
