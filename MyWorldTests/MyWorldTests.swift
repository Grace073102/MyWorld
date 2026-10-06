//
//  MyWorldTests.swift
//  MyWorldTests
//
//  Created by Grace Chi Yen Chong on 28/9/2026.
//

import XCTest
@testable import MyWorld

final class TravelUseCaseTests: XCTestCase {

    var repository: MockTravelRepository!

    override func setUp() {
        super.setUp()
        repository = MockTravelRepository()
    }

    override func tearDown() {
        repository = nil
        super.tearDown()
    }

    func testRecordTripWithEmptyCountryThrowsError() {
        let useCase = RecordTripUseCase(repository: repository)

        XCTAssertThrowsError(
            try useCase.execute(
                name: "Japan Trip",
                country: "",
                countryCode: "",
                startDate: Date(),
                endDate: Date(),
                notes: ""
            )
        ) { error in
            XCTAssertEqual(error as? TravelError, .emptyCountry)
        }
    }

    func testRecordTripWithInvalidDateRangeThrowsError() {
        let useCase = RecordTripUseCase(repository: repository)

        let startDate = Date()
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: startDate
        )!

        XCTAssertThrowsError(
            try useCase.execute(
                name: "Sydney Trip",
                country: "Australia",
                countryCode: "AU",
                startDate: startDate,
                endDate: endDate,
                notes: ""
            )
        ) { error in
            XCTAssertEqual(error as? TravelError, .invalidDateRange)
        }
    }

    func testValidTripIsSaved() throws {
        let useCase = RecordTripUseCase(repository: repository)

        let startDate = Date()
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: 3,
            to: startDate
        )!

        try useCase.execute(
            name: "Sydney Trip",
            country: "Australia",
            countryCode: "AU",
            startDate: startDate,
            endDate: endDate,
            notes: "Holiday"
        )

        XCTAssertEqual(repository.trips.count, 1)
        XCTAssertEqual(repository.trips.first?.name, "Sydney Trip")
        XCTAssertEqual(repository.trips.first?.country, "Australia")
        XCTAssertEqual(repository.trips.first?.countryCode, "AU")
    }

    func testAddPlaceWithEmptyNameThrowsError() {
        let useCase = AddVisitedPlaceUseCase(repository: repository)

        let tripID = UUID()
        let startDate = Date()
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: 5,
            to: startDate
        )!

        XCTAssertThrowsError(
            try useCase.execute(
                tripID: tripID,
                name: "",
                city: "Sydney",
                latitude: -33.8688,
                longitude: 151.2093,
                visitedDate: startDate,
                tripStartDate: startDate,
                tripEndDate: endDate,
                notes: ""
            )
        ) { error in
            XCTAssertEqual(error as? TravelError, .emptyPlaceName)
        }
    }

    func testAddPlaceOutsideTripDatesThrowsError() {
        let useCase = AddVisitedPlaceUseCase(repository: repository)

        let tripID = UUID()
        let startDate = Date()
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: 5,
            to: startDate
        )!

        let visitedDate = Calendar.current.date(
            byAdding: .day,
            value: 10,
            to: startDate
        )!

        XCTAssertThrowsError(
            try useCase.execute(
                tripID: tripID,
                name: "Sydney Opera House",
                city: "Sydney",
                latitude: -33.8568,
                longitude: 151.2153,
                visitedDate: visitedDate,
                tripStartDate: startDate,
                tripEndDate: endDate,
                notes: ""
            )
        ) { error in
            XCTAssertEqual(error as? TravelError, .visitedDateOutsideTrip)
        }
    }

    func testValidPlaceIsSaved() throws {
        let useCase = AddVisitedPlaceUseCase(repository: repository)

        let tripID = UUID()
        let startDate = Date()
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: 5,
            to: startDate
        )!

        let visitedDate = Calendar.current.date(
            byAdding: .day,
            value: 2,
            to: startDate
        )!

        try useCase.execute(
            tripID: tripID,
            name: "Sydney Opera House",
            city: "Sydney",
            latitude: -33.8568,
            longitude: 151.2153,
            visitedDate: visitedDate,
            tripStartDate: startDate,
            tripEndDate: endDate,
            notes: "Visited during the afternoon"
        )

        XCTAssertEqual(repository.places.count, 1)
        XCTAssertEqual(repository.places.first?.name, "Sydney Opera House")
        XCTAssertEqual(repository.places.first?.city, "Sydney")
        XCTAssertEqual(repository.places.first?.tripID, tripID)
    }
    
    func testGetTravelHistoryReturnsSavedTrips() throws {
        let useCase = GetTravelHistoryUseCase(repository: repository)

        let firstTrip = TripModel(
            id: UUID(),
            name: "Japan Trip",
            country: "Japan",
            countryCode: "JP",
            startDate: Date(),
            endDate: Date(),
            notes: ""
        )

        let secondTrip = TripModel(
            id: UUID(),
            name: "Sydney Trip",
            country: "Australia",
            countryCode: "AU",
            startDate: Date(),
            endDate: Date(),
            notes: ""
        )

        repository.trips = [firstTrip, secondTrip]

        let trips = try useCase.execute()

        XCTAssertEqual(trips.count, 2)
        XCTAssertEqual(trips[0].name, "Japan Trip")
        XCTAssertEqual(trips[1].name, "Sydney Trip")
    }
}
