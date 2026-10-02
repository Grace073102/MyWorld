//
//  TripDetailView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 30/9/2026.
//

import SwiftUI

struct TripDetailView: View {

    @State private var trip: TripModel
    @StateObject private var viewModel: TripDetailViewModel

    let repository: TravelRepositoryProtocol

    @Environment(\.dismiss)
    private var dismiss

    @State private var showingEditTrip = false
    @State private var showingAddPlace = false
    @State private var showingDeleteConfirmation = false
    @State private var deleteErrorMessage: String?

    init(trip: TripModel,repository: TravelRepositoryProtocol) {

        _trip = State(initialValue: trip)
        self.repository = repository

        let getPlacesUseCase = GetPlacesForTripUseCase(repository: repository)

        _viewModel = StateObject(
            wrappedValue: TripDetailViewModel(tripID: trip.id, getPlacesForTripUseCase: getPlacesUseCase))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(trip.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 6) {
                        Image(systemName: "globe")
                        Text(trip.country)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(dateRangeText)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Trip Information")
                        .font(.headline)

                    TripInformationRow(
                        icon: "calendar",
                        title: "Start Date",
                        value:
                            trip.startDate.formatted(
                                date: .long,
                                time: .omitted
                            )
                    )

                    Divider()

                    TripInformationRow(
                        icon: "calendar.badge.checkmark",
                        title: "End Date",
                        value:
                            trip.endDate.formatted(
                                date: .long,
                                time: .omitted
                            )
                    )

                    Divider()

                    TripInformationRow(
                        icon: "globe",
                        title: "Country",
                        value: trip.country
                    )
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                if !trip.notes
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty {

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notes")
                            .font(.headline)

                        Text(trip.notes)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Visited Places")
                                .font(.title2)
                                .fontWeight(.bold)
                            if !viewModel.places.isEmpty {
                                Text("\(viewModel.places.count) places")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        Button {
                            showingAddPlace = true
                        } label: {
                            Label("Add", systemImage: "plus")
                                .fontWeight(.semibold)
                        }
                    }

                    if viewModel.places.isEmpty {
                        ContentUnavailableView("No Places Yet", systemImage: "mappin.and.ellipse",
                            description: Text("Add the places you visited during this trip."))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(viewModel.places) { place in
                                NavigationLink {
                                    PlaceDetailView(place: place, trip: trip, repository: repository)
                                } label: {
                                    VisitedPlaceRow(place: place)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Trip Memories")
                        .font(.title2)
                        .fontWeight(.bold)

                    ContentUnavailableView("No Memories Yet", systemImage: "photo.on.rectangle.angled", description: Text("Photos and videos from all places in this trip will appear here."))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }

                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()

                        Image(systemName: "trash")

                        Text("Delete Trip")
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .padding()
                }
                .background(Color.red.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }

        .navigationTitle("Trip")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showingEditTrip = true
                }
            }
        }
        .onAppear {
            viewModel.loadPlaces()
        }

        .sheet(isPresented: $showingEditTrip) {

            let updateTripUseCase = UpdateTripUseCase(repository: repository)
            let editViewModel = EditTripViewModel(trip: trip, updateTripUseCase: updateTripUseCase)

            EditTripView(viewModel: editViewModel) { updatedTrip in
                trip = updatedTrip
            }
        }

        .sheet(isPresented: $showingAddPlace,
            onDismiss: {viewModel.loadPlaces()}
        ) {
            let addPlaceUseCase = AddVisitedPlaceUseCase(repository: repository)
            
            let addPlaceViewModel =
                AddPlaceViewModel(
                    tripID: trip.id,
                    tripStartDate: trip.startDate,
                    tripEndDate: trip.endDate,
                    addVisitedPlaceUseCase: addPlaceUseCase)

            AddPlaceView(viewModel: addPlaceViewModel)
        }

        .confirmationDialog("Delete Trip?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Trip", role: .destructive) {
                deleteTrip()
            }

            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete \(trip.name) and its visited places.")
        }

        .alert("Unable to Delete Trip",
            isPresented:
                Binding(get: {
                        deleteErrorMessage != nil
                    },
                    set: { newValue in
                        if !newValue {
                            deleteErrorMessage = nil
                        }
                    }
                )
        ) {
            Button("OK") {
                deleteErrorMessage = nil
            }
        } message: {
            Text(deleteErrorMessage ?? "")
        }
    }

    private var dateRangeText: String {
        
        let start = trip.startDate.formatted(date: .abbreviated, time: .omitted)
        let end = trip.endDate.formatted(date: .abbreviated, time: .omitted)
        return "\(start) – \(end)"
    }

    private func deleteTrip() {

        let deleteUseCase = DeleteTripUseCase(repository: repository)

        do {
            try deleteUseCase.execute(tripID: trip.id)
            dismiss()
        } catch {
            deleteErrorMessage = error.localizedDescription
        }
    }
}

private struct TripInformationRow: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            Spacer()
        }
    }
}

private struct VisitedPlaceRow: View {

    let place: VisitedPlaceModel
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.10))
                    .frame(width: 48, height: 48)

                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.red)
            }

            VStack(alignment: .leading, spacing: 4) {

                Text(place.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if !place.city.isEmpty {
                    Text(place.city)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }


                Text(place.visitedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
