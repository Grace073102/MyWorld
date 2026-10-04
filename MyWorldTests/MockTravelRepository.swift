//
//  MockTravelRepository.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import Foundation
@testable import MyWorld

final class MockTravelRepository: TravelRepositoryProtocol {

    var trips: [TripModel] = []
    var places: [VisitedPlaceModel] = []
    var mediaItems: [MediaItemModel] = []

    func saveTrip(_ trip: TripModel) throws {
        trips.append(trip)
    }

    func updateTrip(_ trip: TripModel) throws {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else {
            throw RepositoryError.tripNotFound
        }

        trips[index] = trip
    }

    func fetchTrips() throws -> [TripModel] {
        trips
    }

    func fetchTrips(countryCode: String) throws -> [TripModel] {
        trips.filter {
            $0.countryCode.caseInsensitiveCompare(countryCode) == .orderedSame
        }
    }

    func fetchTrip(id: UUID) throws -> TripModel {
        guard let trip = trips.first(where: { $0.id == id }) else {
            throw RepositoryError.tripNotFound
        }

        return trip
    }

    func deleteTrip(id: UUID) throws {
        guard trips.contains(where: { $0.id == id }) else {
            throw RepositoryError.tripNotFound
        }

        trips.removeAll { $0.id == id }
        places.removeAll { $0.tripID == id }
    }

    func savePlace(_ place: VisitedPlaceModel) throws {
        places.append(place)
    }

    func updatePlace(_ place: VisitedPlaceModel) throws {
        guard let index = places.firstIndex(where: { $0.id == place.id }) else {
            throw RepositoryError.placeNotFound
        }

        places[index] = place
    }

    func fetchPlaces(tripID: UUID) throws -> [VisitedPlaceModel] {
        places.filter { $0.tripID == tripID }
    }

    func fetchAllPlaces() throws -> [VisitedPlaceModel] {
        places
    }

    func deletePlace(id: UUID) throws {
        guard places.contains(where: { $0.id == id }) else {
            throw RepositoryError.placeNotFound
        }

        places.removeAll { $0.id == id }
        mediaItems.removeAll { mediaItem in
            mediaItem.placeID == id
        }
    }

    func saveMediaItem(_ mediaItem: MediaItemModel) throws {
        mediaItems.append(mediaItem)
    }

    func fetchMediaItems(placeID: UUID) throws -> [MediaItemModel] {
        mediaItems.filter { $0.placeID == placeID }
    }

    func fetchMediaItems(tripID: UUID) throws -> [MediaItemModel] {
        let placeIDs = Set(
            places
                .filter { $0.tripID == tripID }
                .map { $0.id }
        )

        return mediaItems.filter {
            placeIDs.contains($0.placeID)
        }
    }

    func deleteMediaItem(id: UUID) throws {
        mediaItems.removeAll { $0.id == id }
    }
}
