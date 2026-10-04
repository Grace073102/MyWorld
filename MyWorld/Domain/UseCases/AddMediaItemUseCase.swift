//
//  AddMediaItemUseCase.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation

struct AddMediaItemUseCase {
    private let repository: TravelRepositoryProtocol

    init(repository: TravelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(placeID: UUID, fileName: String, mediaType: String) throws {
        let mediaItem = MediaItemModel(
            id: UUID(),
            fileName: fileName,
            mediaType: mediaType,
            createdDate: Date(),
            placeID: placeID
        )

        try repository.saveMediaItem(mediaItem)
    }
}
