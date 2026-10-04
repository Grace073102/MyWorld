//
//  EditPlaceView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 2/10/2026.
//

import SwiftUI
import MapKit

struct EditPlaceView: View {

    @StateObject private var viewModel: EditPlaceViewModel
    @StateObject private var searchService: PlaceSearchService

    @Environment(\.dismiss)
    private var dismiss

    let onSave: (VisitedPlaceModel) -> Void

    init(viewModel: EditPlaceViewModel, countryCode: String, countryName: String, onSave: @escaping (VisitedPlaceModel) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _searchService = StateObject(wrappedValue: PlaceSearchService(countryCode: countryCode, countryName: countryName))
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Place") {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.red)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(viewModel.name)
                                .fontWeight(.semibold)

                            if !viewModel.city.isEmpty {
                                Text(viewModel.city)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Change Place") {
                    TextField("Search for a place", text: $searchService.searchText)
                        .onChange(of: searchService.searchText) { _, newValue in
                            searchService.search(newValue)
                        }

                    ForEach(searchService.results, id: \.self) { result in
                        Button {
                            Task {
                                do {
                                    let mapItem = try await searchService.getMapItem(from: result)
                                    viewModel.selectPlace(mapItem)
                                    searchService.searchText = ""
                                    searchService.results = []
                                } catch {
                                    viewModel.errorMessage = error.localizedDescription
                                }
                            }
                        } label: {
                            VStack(alignment: .leading,spacing: 3) {
                                Text(result.title)
                                    .foregroundStyle(.primary)

                                if !result.subtitle.isEmpty {
                                    Text(result.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                Section("Visited Date") {
                    DatePicker("Date", selection: $viewModel.visitedDate, in: viewModel.validDateRange, displayedComponents: .date)
                }

                Section("Notes") {
                    TextEditor(text: $viewModel.notes)
                    .frame(minHeight: 100)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Edit Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()

                        if viewModel.didSave {
                            let updatedPlace = VisitedPlaceModel(
                                id: originalPlaceID,
                                name: viewModel.name,
                                city: viewModel.city,
                                latitude: viewModel.latitude,
                                longitude: viewModel.longitude,
                                visitedDate: viewModel.visitedDate,
                                notes: viewModel.notes,
                                tripID: originalTripID
                            )

                            onSave(updatedPlace)
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var originalPlaceID: UUID {
        viewModel.placeIDForView
    }

    private var originalTripID: UUID {
        viewModel.tripIDForView
    }
}
