//
//  TripMediaViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation
import Combine

@MainActor
final class TripMediaViewModel: ObservableObject {

    @Published var mediaItems: [MediaItemModel] = []
    @Published var errorMessage: String?

    private let tripID: UUID
    private let getMediaItemsForTripUseCase: GetMediaItemsForTripUseCase

    init(tripID: UUID, getMediaItemsForTripUseCase: GetMediaItemsForTripUseCase) {
        self.tripID = tripID
        self.getMediaItemsForTripUseCase = getMediaItemsForTripUseCase
    }

    func loadMedia() {
        do {
            mediaItems = try getMediaItemsForTripUseCase.execute(tripID: tripID)
            errorMessage = nil
        } catch {
            mediaItems = []
            errorMessage = error.localizedDescription
        }
    }
}
