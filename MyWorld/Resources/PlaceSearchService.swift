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

    override init() {
        super.init()

        completer.delegate = self

        // Return places and addresses
        completer.resultTypes = [
            .pointOfInterest,
            .address
        ]
    }

    func search(_ text: String) {
        searchText = text
        completer.queryFragment = text

        if text.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {
            results = []
        }
    }

    func getMapItem(
        from completion: MKLocalSearchCompletion
    ) async throws -> MKMapItem {

        let request = MKLocalSearch.Request(
            completion: completion
        )

        let search = MKLocalSearch(
            request: request
        )

        let response = try await search.start()

        guard let mapItem = response.mapItems.first else {
            throw PlaceSearchError.noResult
        }

        return mapItem
    }
}

extension PlaceSearchService:
    MKLocalSearchCompleterDelegate {

    nonisolated func completerDidUpdateResults(
        _ completer: MKLocalSearchCompleter
    ) {
        let newResults = completer.results

        Task { @MainActor in
            self.results = newResults
        }
    }

    nonisolated func completer(
        _ completer: MKLocalSearchCompleter,
        didFailWithError error: Error
    ) {
        print(
            "Place search error:",
            error.localizedDescription
        )
    }
}

enum PlaceSearchError: Error {
    case noResult
}
