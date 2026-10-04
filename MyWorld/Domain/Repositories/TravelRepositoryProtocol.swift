//
//  TravelRepositoryProtocol.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

protocol TravelRepositoryProtocol {
    
    //Trips
    
    func saveTrip(_ trip: TripModel) throws
    
    func fetchTrips() throws -> [TripModel]
    
    func fetchTrips(countryCode: String) throws -> [TripModel]
    
    func deleteTrip(id: UUID) throws
    
    func updateTrip(_ trip: TripModel) throws
    
    func fetchTrip(id: UUID) throws -> TripModel
    
    //Places
    
    func savePlace(_ place: VisitedPlaceModel) throws
    
    func fetchPlaces(tripID: UUID) throws -> [VisitedPlaceModel]
    
    func fetchAllPlaces() throws -> [VisitedPlaceModel]
    
    func updatePlace(_ place: VisitedPlaceModel) throws
    
    func deletePlace(id: UUID) throws
    
    //Media
    func saveMediaItem(_ mediaItem: MediaItemModel) throws
    
    func fetchMediaItems(placeID: UUID) throws -> [MediaItemModel]
    
    func fetchMediaItems(tripID: UUID) throws -> [MediaItemModel]
    
    func deleteMediaItem(id: UUID) throws
}
