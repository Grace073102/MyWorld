//
//  GetTravelHistoryUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

struct GetTravelHistoryUseCase {

    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute() throws -> [TripModel] {
        try repository.fetchTrips()
    }
}
