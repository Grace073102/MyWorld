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
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)]
        
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
        
        request.predicate = NSPredicate(format: "countryCode ==[c] %@", countryCode)
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)]
        
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
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        request.fetchLimit = 1
        
        if let trip = try context.fetch(request).first {
            context.delete(trip)
            try context.save()
        }
    }
    
    func savePlace(_ place: VisitedPlaceModel) throws {
        let tripRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        tripRequest.predicate = NSPredicate(format: "id == %@", place.tripID as CVarArg)
        
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
        let request: NSFetchRequest<VisitedPlace> = VisitedPlace.fetchRequest()

        request.predicate =
            NSPredicate(format: "trip.id == %@", tripID as CVarArg)

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

        request.predicate = NSPredicate(format: "id == %@", trip.id as CVarArg)

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
    
    func fetchAllPlaces() throws -> [VisitedPlaceModel] {

        let request: NSFetchRequest<VisitedPlace> = VisitedPlace.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "visitedDate", ascending: true)
        ]

        let entities = try context.fetch(request)

        return entities.compactMap { entity in

            guard let id = entity.id,
                  let tripID = entity.trip?.id else {
                return nil
            }

            return VisitedPlaceModel(
                id: id,
                name: entity.name ?? "",
                city: entity.city ?? "",
                latitude: entity.latitude,
                longitude: entity.longitude,
                visitedDate: entity.visitedDate ?? Date(),
                notes: entity.notes ?? "",
                tripID: tripID
            )
        }
    }
    
    func updatePlace(_ place: VisitedPlaceModel) throws {

        let request: NSFetchRequest<VisitedPlace> = VisitedPlace.fetchRequest()

        request.predicate = NSPredicate(format: "id == %@", place.id as CVarArg)

        request.fetchLimit = 1

        guard let entity = try context.fetch(request).first else {
            throw RepositoryError.placeNotFound
        }

        entity.name = place.name
        entity.city = place.city
        entity.latitude = place.latitude
        entity.longitude = place.longitude
        entity.visitedDate = place.visitedDate
        entity.notes = place.notes

        try context.save()
    }
    
    func fetchTrip(id: UUID) throws -> TripModel {

        let request: NSFetchRequest<Trip> = Trip.fetchRequest()

        request.fetchLimit = 1

        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let entity = try context.fetch(request).first else {
            throw RepositoryError.tripNotFound
        }

        return TripModel(
            id: entity.id ?? id,
            name: entity.name ?? "",
            country: entity.country ?? "",
            countryCode: entity.countryCode ?? "",
            startDate: entity.startDate ?? Date(),
            endDate: entity.endDate ?? Date(),
            notes: entity.notes ?? ""
        )
    }
    
    func deletePlace(id: UUID) throws {
        let request: NSFetchRequest<VisitedPlace> = VisitedPlace.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        guard let entity = try context.fetch(request).first else {
            throw RepositoryError.placeNotFound
        }

        context.delete(entity)
        try context.save()
    }
    
    func saveMediaItem(_ mediaItem: MediaItemModel) throws {
        let placeRequest: NSFetchRequest<VisitedPlace> = VisitedPlace.fetchRequest()
        placeRequest.fetchLimit = 1
        placeRequest.predicate = NSPredicate(format: "id == %@", mediaItem.placeID as CVarArg)

        guard let placeEntity = try context.fetch(placeRequest).first else {
            throw RepositoryError.placeNotFound
        }

        let entity = MediaItem(context: context)
        entity.id = mediaItem.id
        entity.fileName = mediaItem.fileName
        entity.mediaType = mediaItem.mediaType
        entity.createdDate = mediaItem.createdDate
        entity.place = placeEntity

        try context.save()
    }

    func fetchMediaItems(placeID: UUID) throws -> [MediaItemModel] {
        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.predicate = NSPredicate(format: "place.id == %@", placeID as CVarArg)
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdDate", ascending: false)
        ]

        return try context.fetch(request).compactMap { entity in
            guard let id = entity.id,
                  let placeID = entity.place?.id else {
                return nil
            }

            return MediaItemModel(
                id: id,
                fileName: entity.fileName ?? "",
                mediaType: entity.mediaType ?? "",
                createdDate: entity.createdDate ?? Date(),
                placeID: placeID
            )
        }
    }

    func fetchMediaItems(tripID: UUID) throws -> [MediaItemModel] {
        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.predicate = NSPredicate(format: "place.trip.id == %@", tripID as CVarArg)
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdDate", ascending: false)
        ]

        return try context.fetch(request).compactMap { entity in
            guard let id = entity.id,
                  let placeID = entity.place?.id else {
                return nil
            }

            return MediaItemModel(
                id: id,
                fileName: entity.fileName ?? "",
                mediaType: entity.mediaType ?? "",
                createdDate: entity.createdDate ?? Date(),
                placeID: placeID
            )
        }
    }

    func deleteMediaItem(id: UUID) throws {
        let request: NSFetchRequest<MediaItem> = MediaItem.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let entity = try context.fetch(request).first else {
            return
        }

        context.delete(entity)
        try context.save()
    }
}
