//
//  PlaceDetailView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 2/10/2026.
//

import SwiftUI
import MapKit

struct PlaceDetailView: View {

    @State private var place: VisitedPlaceModel
    @State private var showingEditPlace = false
    @State private var showingDeleteConfirmation = false
    @State private var deleteErrorMessage: String?

    @Environment(\.dismiss) private var dismiss

    let trip: TripModel
    let repository: TravelRepositoryProtocol

    init(
        place: VisitedPlaceModel,
        trip: TripModel,
        repository: TravelRepositoryProtocol
    ) {
        _place = State(initialValue: place)
        self.trip = trip
        self.repository = repository
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.10))
                                .frame(width: 54, height: 54)

                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(.red)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text(place.name)
                                .font(.title2)
                                .fontWeight(.bold)

                            if !place.city.isEmpty {
                                Text(place.city)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()
                    }
                }

                Map(
                    initialPosition: .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: place.latitude,
                                longitude: place.longitude
                            ),
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.02,
                                longitudeDelta: 0.02
                            )
                        )
                    ),
                    interactionModes: [.pan, .zoom]
                ) {
                    Annotation(
                        "",
                        coordinate: CLLocationCoordinate2D(
                            latitude: place.latitude,
                            longitude: place.longitude
                        ),
                        anchor: .bottom
                    ) {
                        PlaceMapMarker()
                    }
                }
                .mapStyle(
                    .standard(
                        elevation: .flat,
                        emphasis: .muted,
                        pointsOfInterest: .all
                    )
                )
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 16) {
                    Text("Place Information")
                        .font(.headline)

                    PlaceInformationRow(
                        icon: "calendar",
                        title: "Visited",
                        value: place.visitedDate.formatted(
                            date: .long,
                            time: .omitted
                        )
                    )

                    if !place.city.isEmpty {
                        PlaceInformationRow(
                            icon: "building.2",
                            title: "City",
                            value: place.city
                        )
                    }

                    PlaceInformationRow(
                        icon: "airplane",
                        title: "Trip",
                        value: trip.name
                    )
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                if !place.notes
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notes")
                            .font(.headline)

                        Text(place.notes)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Photos & Videos")
                            .font(.headline)

                        Spacer()
                    }

                    ContentUnavailableView(
                        "No Memories Yet",
                        systemImage: "photo.on.rectangle.angled",
                        description: Text(
                            "Photos and videos from this place will appear here."
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Label(
                        "Delete Place",
                        systemImage: "trash"
                    )
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .padding()
        }
        .navigationTitle("Place")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showingEditPlace = true
                }
            }
        }
        .sheet(isPresented: $showingEditPlace) {
            let updateUseCase = UpdateVisitedPlaceUseCase(
                repository: repository
            )

            let editViewModel = EditPlaceViewModel(
                place: place,
                tripStartDate: trip.startDate,
                tripEndDate: trip.endDate,
                updateVisitedPlaceUseCase: updateUseCase
            )

            EditPlaceView(
                viewModel: editViewModel
            ) { updatedPlace in
                place = updatedPlace
            }
        }
        .alert("Delete Place?", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}

            Button("Delete Place", role: .destructive) {
                deletePlace()
            }
        } message: {
            Text("This will permanently delete \(place.name) from this trip.")
        }
        .alert(
            "Unable to Delete Place",
            isPresented: Binding(
                get: {
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

    private func deletePlace() {
        let deleteUseCase = DeleteVisitedPlaceUseCase(
            repository: repository
        )

        do {
            try deleteUseCase.execute(
                placeID: place.id
            )

            deleteErrorMessage = nil
            dismiss()
        } catch {
            deleteErrorMessage = error.localizedDescription
        }
    }
}

private struct PlaceInformationRow: View {

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
