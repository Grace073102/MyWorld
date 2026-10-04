//
//  EditPlaceViewModel.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 2/10/2026.
//

import Foundation
import MapKit
import Combine

@MainActor
final class EditPlaceViewModel: ObservableObject {

    @Published var name: String
    @Published var city: String

    @Published var latitude: Double
    @Published var longitude: Double

    @Published var visitedDate: Date
    @Published var notes: String

    @Published var errorMessage: String?
    @Published var didSave = false

    private let placeID: UUID
    private let tripID: UUID

    private let tripStartDate: Date
    private let tripEndDate: Date

    private let updateVisitedPlaceUseCase: UpdateVisitedPlaceUseCase

    init(
        place: VisitedPlaceModel,
        tripStartDate: Date,
        tripEndDate: Date,
        updateVisitedPlaceUseCase:
            UpdateVisitedPlaceUseCase
    ) {

        self.placeID = place.id
        self.tripID = place.tripID

        self.name = place.name
        self.city = place.city

        self.latitude = place.latitude
        self.longitude = place.longitude

        self.visitedDate = place.visitedDate
        self.notes = place.notes

        self.tripStartDate = tripStartDate
        self.tripEndDate = tripEndDate

        self.updateVisitedPlaceUseCase = updateVisitedPlaceUseCase
    }


    var validDateRange: ClosedRange<Date> {
        tripStartDate...tripEndDate
    }

    var placeIDForView: UUID {
        placeID
    }

    var tripIDForView: UUID {
        tripID
    }

    func selectPlace(_ mapItem: MKMapItem) {
        name = mapItem.name ?? "Unknown Place"

        city = mapItem.addressRepresentations?.cityName ?? mapItem.address?.shortAddress ?? ""

        latitude = mapItem.location.coordinate.latitude

        longitude = mapItem.location.coordinate.longitude

        errorMessage = nil
    }

    

    // MARK: - Save

    func save() {

        do {

            try updateVisitedPlaceUseCase.execute(
                id: placeID,
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

            errorMessage = nil
            didSave = true

        } catch {

            errorMessage =
                error.localizedDescription

            didSave = false
        }
    }
}
