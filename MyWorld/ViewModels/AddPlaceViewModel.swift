//
//  AddPlaceViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 30/9/2026.
//

import Foundation
import MapKit
import Combine
import WidgetKit

@MainActor
final class AddPlaceViewModel: ObservableObject {

    @Published var name = ""
    @Published var city = ""

    @Published var latitude: Double?
    @Published var longitude: Double?

    @Published var visitedDate = Date()
    @Published var notes = ""

    @Published var errorMessage: String?
    @Published var didSave = false

    private let tripID: UUID
    private let addVisitedPlaceUseCase: AddVisitedPlaceUseCase
    private let updateTravelSummaryUseCase: UpdateTravelSummaryUseCase
    private let tripStartDate: Date
    private let tripEndDate: Date

    init(
        tripID: UUID,
        tripStartDate: Date,
        tripEndDate: Date,
        addVisitedPlaceUseCase: AddVisitedPlaceUseCase,
        updateTravelSummaryUseCase: UpdateTravelSummaryUseCase
    ) {
        self.tripID = tripID
        self.tripStartDate = tripStartDate
        self.tripEndDate = tripEndDate
        self.addVisitedPlaceUseCase = addVisitedPlaceUseCase
        self.updateTravelSummaryUseCase = updateTravelSummaryUseCase

        self.visitedDate = tripStartDate
    }

    var validDateRange: ClosedRange<Date> {
        tripStartDate...tripEndDate
    }

    func selectPlace(_ mapItem: MKMapItem) {

        name = mapItem.name ?? "Unknown Place"
        city = mapItem.addressRepresentations?.cityName ?? mapItem.address?.shortAddress ?? ""
        latitude = mapItem.location.coordinate.latitude
        longitude = mapItem.location.coordinate.longitude

        errorMessage = nil
    }

    func savePlace() {

        guard let latitude,
              let longitude else {

            errorMessage = "Please search for and select a place."
            return
        }

        do {
            try addVisitedPlaceUseCase.execute(
                tripID: tripID,
                name: name,
                city: city,
                latitude: latitude,
                longitude: longitude,
                visitedDate: visitedDate,
                tripStartDate: tripStartDate,
                tripEndDate: tripEndDate,
                notes: notes
            )

            try updateTravelSummaryUseCase.execute()
            WidgetCenter.shared.reloadTimelines(ofKind: "MyWorldWidget")

            errorMessage = nil
            didSave = true
        } catch {
            errorMessage =
                error.localizedDescription
            didSave = false
        }
    }
}
