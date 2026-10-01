//
//  TravelRepositoryProtocol.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

protocol TravelRepositoryProtocol {
    
    // MARK: - Trips
    
    func saveTrip(_ trip: TripModel) throws
    
    func fetchTrips() throws -> [TripModel]
    
    func fetchTrips(countryCode: String) throws -> [TripModel]
    
    func deleteTrip(id: UUID) throws
    
    func updateTrip(_ trip: TripModel) throws
    
    // MARK: - Places
    
    func savePlace(_ place: VisitedPlaceModel) throws
    
    func fetchPlaces(tripID: UUID) throws -> [VisitedPlaceModel]
    
    func fetchAllPlaces() throws -> [VisitedPlaceModel]
    
    func updatePlace(_ place: VisitedPlaceModel) throws
}
