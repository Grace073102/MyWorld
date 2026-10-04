//
//  PlaceMediaViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation
import Combine

@MainActor
final class PlaceMediaViewModel: ObservableObject {

    @Published var mediaItems: [MediaItemModel] = []
    @Published var errorMessage: String?

    private let placeID: UUID
    private let addMediaItemUseCase: AddMediaItemUseCase
    private let getMediaItemsForPlaceUseCase: GetMediaItemsForPlaceUseCase

    init(placeID: UUID, addMediaItemUseCase: AddMediaItemUseCase, getMediaItemsForPlaceUseCase: GetMediaItemsForPlaceUseCase) {
        self.placeID = placeID
        self.addMediaItemUseCase = addMediaItemUseCase
        self.getMediaItemsForPlaceUseCase = getMediaItemsForPlaceUseCase
    }

    func loadMedia() {
        do {
            mediaItems = try getMediaItemsForPlaceUseCase.execute(placeID: placeID)
            errorMessage = nil
        } catch {
            mediaItems = []
            errorMessage = error.localizedDescription
        }
    }

    func addMedia(data: Data, mediaType: String, fileExtension: String) {
        do {
            let fileName = try MediaStorageService.shared.save(data: data, fileExtension: fileExtension)

            do {
                try addMediaItemUseCase.execute(
                    placeID: placeID,
                    fileName: fileName,
                    mediaType: mediaType
                )

                loadMedia()
            } catch {
                try? MediaStorageService.shared.delete(fileName: fileName)
                throw error
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
