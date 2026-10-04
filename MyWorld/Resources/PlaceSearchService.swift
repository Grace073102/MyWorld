//
//  PlaceSearchService.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 1/10/2026.
//

import Foundation
import MapKit
import Combine

@MainActor
final class PlaceSearchService: NSObject, ObservableObject {

    @Published var results: [MKLocalSearchCompletion] = []
    @Published var searchText = ""

    private let completer = MKLocalSearchCompleter()
    private let countryCode: String
    private let countryName: String

    init(countryCode: String, countryName: String) {
        self.countryCode = countryCode.uppercased()
        self.countryName = countryName
        super.init()

        completer.delegate = self
        completer.resultTypes = [.pointOfInterest, .address]
    }

    func search(_ text: String) {
        searchText = text

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            results = []
            completer.queryFragment = ""
            return
        }

        completer.queryFragment = "\(text), \(countryName)"
    }

    func getMapItem(from completion: MKLocalSearchCompletion) async throws -> MKMapItem {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        guard let mapItem = response.mapItems.first else {
            throw PlaceSearchError.noResult
        }

        guard mapItem.addressRepresentations?.region?.identifier.uppercased() == countryCode else {
            throw PlaceSearchError.outsideTripCountry(countryName)
        }

        return mapItem
    }
}

extension PlaceSearchService: MKLocalSearchCompleterDelegate {

    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let newResults = completer.results

        Task { @MainActor in
            self.results = newResults
        }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Place search error:", error.localizedDescription)
    }
}

enum PlaceSearchError: LocalizedError {
    case noResult
    case outsideTripCountry(String)

    var errorDescription: String? {
        switch self {
        case .noResult:
            return "The selected place could not be found."
        case .outsideTripCountry(let country):
            return "Please select a place located in \(country)."
        }
    }
}
