//
//  DeleteTripUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 30/9/2026.
//

import Foundation

struct DeleteTripUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(tripID: UUID) throws {
        try repository.deleteTrip(id: tripID)
    }
}
