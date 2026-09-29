//
//  AddTripViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation
import Combine

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

    init(recordTripUseCase: RecordTripUseCase) {
        self.recordTripUseCase = recordTripUseCase
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
