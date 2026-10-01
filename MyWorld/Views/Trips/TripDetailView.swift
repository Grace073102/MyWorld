//
//  TripDetailView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 30/9/2026.
//

import SwiftUI

struct TripDetailView: View {

    @State private var trip: TripModel
    let repository: TravelRepositoryProtocol
    
    @State private var showingEditTrip = false
    @State private var showingDeleteConfirmation = false
    @State private var deleteErrorMessage: String?
    @State private var showingAddPlace = false
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        trip: TripModel,
        repository: TravelRepositoryProtocol
    ) {
        _trip = State(initialValue: trip)
        self.repository = repository
    }

    var body: some View {
        List {

            Section("Trip Information") {

                LabeledContent(
                    "Country",
                    value: trip.country
                )

                LabeledContent(
                    "Start Date",
                    value: trip.startDate.formatted(
                        date: .long,
                        time: .omitted
                    )
                )

                LabeledContent(
                    "End Date",
                    value: trip.endDate.formatted(
                        date: .long,
                        time: .omitted
                    )
                )
            }

            if !trip.notes.isEmpty {
                Section("Notes") {
                    Text(trip.notes)
                }
            }

            Section {
                ContentUnavailableView(
                    "No Places Yet",
                    systemImage: "mappin.and.ellipse",
                    description: Text(
                        "Add places you visited during this trip."
                    )
                )

                Button {
                    showingAddPlace = true
                } label: {
                    Label(
                        "Add Visited Place",
                        systemImage: "plus.circle.fill"
                    )
                }

            } header: {
                Text("Visited Places")
            }
            
            Section {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()

                        Label(
                            "Delete Trip",
                            systemImage: "trash"
                        )

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button("Edit") {
                    showingEditTrip = true
                }
            }
        }
        .sheet(
            isPresented: $showingEditTrip
        ) {

            let updateUseCase = UpdateTripUseCase(
                repository: repository
            )

            let editViewModel = EditTripViewModel(
                trip: trip,
                updateTripUseCase: updateUseCase
            )

            EditTripView(
                viewModel: editViewModel
            ) { updatedTrip in
                trip = updatedTrip
            }
        }
        .sheet(
            isPresented: $showingAddPlace
        ) {

            let addPlaceUseCase = AddVisitedPlaceUseCase(repository: repository)

            let addPlaceViewModel = AddPlaceViewModel(
                    tripID: trip.id,
                    tripStartDate: trip.startDate,
                    tripEndDate: trip.endDate,
                    addVisitedPlaceUseCase: addPlaceUseCase
            )

            AddPlaceView(viewModel: addPlaceViewModel)
        }
        .alert("Delete Trip?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteTrip()
            }

            Button("Cancel", role: .cancel) { }

        } message: {
            Text("Are you sure you want to delete \"\(trip.name)\"? This action cannot be undone.")
        }
        .alert(
            "Delete Failed",
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
    
    private func deleteTrip() {
        let deleteUseCase = DeleteTripUseCase(repository: repository)

        do {
            try deleteUseCase.execute(
                tripID: trip.id
            )
            dismiss()
        } catch {
            deleteErrorMessage = "Unable to delete this trip."
        }
    }
}

