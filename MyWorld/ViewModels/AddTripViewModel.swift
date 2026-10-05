//
//  AddTripViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation
import Combine
import WidgetKit

@MainActor
final class AddTripViewModel: ObservableObject {

    @Published var name = ""
    @Published var country = ""
    @Published var countryCode = ""
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var notes = ""

    @Published var errorMessage: String?
    @Published var didSave = false

    private let recordTripUseCase: RecordTripUseCase
    private let updateTravelSummaryUseCase: UpdateTravelSummaryUseCase

    init(recordTripUseCase: RecordTripUseCase, updateTravelSummaryUseCase: UpdateTravelSummaryUseCase) {
        self.recordTripUseCase = recordTripUseCase
        self.updateTravelSummaryUseCase = updateTravelSummaryUseCase
    }

    func saveTrip() {
        do {
            try recordTripUseCase.execute(
                name: name,
                country: country,
                countryCode: countryCode,
                startDate: startDate,
                endDate: endDate,
                notes: notes
            )

            try updateTravelSummaryUseCase.execute()
            WidgetCenter.shared.reloadTimelines(ofKind: "MyWorldWidget")

            errorMessage = nil
            didSave = true
        } catch {
            errorMessage = error.localizedDescription
            didSave = false
        }
    }

    private func clearForm() {
        name = ""
        country = ""
        countryCode = ""
        startDate = Date()
        endDate = Date()
        notes = ""
    }
}
