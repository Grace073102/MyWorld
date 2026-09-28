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
    
    
    // MARK: - Places
    
    func savePlace(_ place: VisitedPlaceModel) throws
    
    func fetchPlaces(tripID: UUID) throws -> [VisitedPlaceModel]
}
