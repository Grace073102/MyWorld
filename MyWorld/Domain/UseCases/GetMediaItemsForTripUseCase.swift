//
//  GetMediaItemsForTripUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation

struct GetMediaItemsForTripUseCase {
    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(tripID: UUID) throws -> [MediaItemModel] {
        try repository.fetchMediaItems(tripID: tripID)
    }
}
