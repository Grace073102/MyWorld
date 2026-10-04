//
//  GetMediaItemsForPlaceUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation

struct GetMediaItemsForPlaceUseCase {
    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(placeID: UUID) throws -> [MediaItemModel] {
        try repository.fetchMediaItems(placeID: placeID)
    }
}
