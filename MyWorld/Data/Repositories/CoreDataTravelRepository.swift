//
//  CoreDataTravelRepository.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation
import CoreData

final class CoreDataTravelRepository: TravelRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func saveTrip(_ trip: TripModel) throws {
        let entity = Trip(context: context)
        
        entity.id = trip.id
        entity.name = trip.name
        entity.country = trip.country
        entity.countryCode = trip.countryCode
        entity.startDate = trip.startDate
        entity.endDate = trip.endDate
        entity.notes = trip.notes
        
        try context.save()
    }
    
    
    func fetchTrips() throws -> [TripModel] {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Trip.startDate,
                ascending: false
            )
        ]
        
        let results = try context.fetch(request)
        
        return results.map { entity in
            TripModel(
                id: entity.id ?? UUID(),
                name: entity.name ?? "",
                country: entity.country ?? "",
                countryCode: entity.countryCode ?? "",
                startDate: entity.startDate ?? Date(),
                endDate: entity.endDate ?? Date(),
                notes: entity.notes ?? ""
            )
        }
    }
    
    
    func fetchTrips(countryCode: String) throws -> [TripModel] {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "countryCode ==[c] %@",
            countryCode
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Trip.startDate,
                ascending: false
            )
        ]
        
        let results = try context.fetch(request)
        
        return results.map { entity in
            TripModel(
                id: entity.id ?? UUID(),
                name: entity.name ?? "",
                country: entity.country ?? "",
                countryCode: entity.countryCode ?? "",
                startDate: entity.startDate ?? Date(),
                endDate: entity.endDate ?? Date(),
                notes: entity.notes ?? ""
            )
        }
    }
    
    func deleteTrip(id: UUID) throws {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        
        request.fetchLimit = 1
        
        if let trip = try context.fetch(request).first {
            context.delete(trip)
            try context.save()
        }
    }
    
    func savePlace(_ place: VisitedPlaceModel) throws {
        let tripRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        tripRequest.predicate = NSPredicate(
            format: "id == %@",
            place.tripID as CVarArg
        )
        
        tripRequest.fetchLimit = 1
        
        guard let trip = try context.fetch(tripRequest).first else {
            throw RepositoryError.tripNotFound
        }
        
        let entity = VisitedPlace(context: context)
        
        entity.id = place.id
        entity.name = place.name
        entity.city = place.city
        entity.latitude = place.latitude
        entity.longitude = place.longitude
        entity.visitedDate = place.visitedDate
        entity.notes = place.notes
        entity.trip = trip
        
        try context.save()
    }
    
    func fetchPlaces(tripID: UUID) throws -> [VisitedPlaceModel] {
        let request: NSFetchRequest<VisitedPlace> =
            VisitedPlace.fetchRequest()

        request.predicate =
            NSPredicate(
                format: "trip.id == %@",
                tripID as CVarArg
            )

        request.sortDescriptors = [
            NSSortDescriptor(key: "visitedDate", ascending: true)
        ]

        let entities =
            try context.fetch(request)

        return entities.map { entity in
            VisitedPlaceModel(
                id: entity.id ?? UUID(),
                name: entity.name ?? "",
                city: entity.city ?? "",
                latitude: entity.latitude,
                longitude: entity.longitude,
                visitedDate:
                    entity.visitedDate ?? Date(),
                notes:
                    entity.notes ?? "",
                tripID: tripID
            )
        }
    }
    
    func updateTrip(_ trip: TripModel) throws {

        let request: NSFetchRequest<Trip> = Trip.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            trip.id as CVarArg
        )

        request.fetchLimit = 1

        guard let entity = try context.fetch(request).first else {
            throw RepositoryError.tripNotFound
        }

        entity.name = trip.name
        entity.country = trip.country
        entity.countryCode = trip.countryCode
        entity.startDate = trip.startDate
        entity.endDate = trip.endDate
        entity.notes = trip.notes

        try context.save()
    }
}
