//
//  TripsViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation
import Combine

@MainActor
final class TripsViewModel: ObservableObject {

    @Published var trips: [TripModel] = []
    @Published var errorMessage: String?

    private let getTravelHistoryUseCase: GetTravelHistoryUseCase

    init(getTravelHistoryUseCase: GetTravelHistoryUseCase) {
        self.getTravelHistoryUseCase = getTravelHistoryUseCase
    }

    func loadTrips() {
        do {
            trips = try getTravelHistoryUseCase.execute()
            errorMessage = nil
        } catch {
            errorMessage = "Unable to load your trips."
        }
    }
}
