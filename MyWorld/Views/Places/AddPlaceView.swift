//
//  AddPlaceView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 1/10/2026.
//

import SwiftUI
import MapKit

struct AddPlaceView: View {

    @StateObject private var viewModel: AddPlaceViewModel
    @StateObject private var searchService = PlaceSearchService()

    @Environment(\.dismiss)
    private var dismiss

    init(viewModel: AddPlaceViewModel) {
        _viewModel =
            StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Search Place") {
                    TextField("Search for a place...", text: $searchService.searchText)
                    .onChange(of: searchService.searchText) { _, newValue in
                        searchService.search(newValue)
                    }

                    if !searchService.results.isEmpty {
                        ForEach(searchService.results, id: \.self) { result in
                            Button {
                                selectSearchResult(result)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
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
                }

                if !viewModel.name.isEmpty {
                    Section("Selected Place") {
                        LabeledContent("Place", value: viewModel.name)
                        
                        if !viewModel.city.isEmpty {
                            LabeledContent("City", value: viewModel.city)
                        }

                        Label("Location selected", systemImage: "mappin.circle.fill")
                            .foregroundStyle(.green)
                    }
                }

                Section("Visit Date") {
                    DatePicker("Visited Date", selection: $viewModel.visitedDate, in: viewModel.validDateRange, displayedComponents: .date)
                }

                Section("Notes") {
                    TextField("Notes", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Label {
                            Text(errorMessage)
                        } icon: {
                            Image(systemName:"exclamationmark.triangle.fill")
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.savePlace()
                    }
                    .fontWeight(.semibold)
                    .disabled(viewModel.latitude == nil || viewModel.longitude == nil)
                }
            }
            .onChange(of: viewModel.didSave) { _, didSave in
                if didSave {
                    dismiss()
                }
            }
        }
    }

    private func selectSearchResult(_ result: MKLocalSearchCompletion) {
        Task {
            do {
                let mapItem =
                    try await searchService.getMapItem(from: result)

                viewModel.selectPlace(mapItem)
                searchService.searchText = ""
                searchService.results = []
            } catch {
                viewModel.errorMessage = "Unable to load this place. Please try again."
            }
        }
    }
}
