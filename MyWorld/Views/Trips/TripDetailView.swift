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

            Section("Visited Places") {
                ContentUnavailableView(
                    "No Places Yet",
                    systemImage: "mappin.and.ellipse",
                    description: Text(
                        "Add places you visited during this trip."
                    )
                )
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
    }
}
