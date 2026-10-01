//
//  ContentView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 28/9/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    var body: some View {

        TabView {

            // MARK: - My World

            MyWorldContainerView(
                context: context
            )
            .tabItem {
                Label(
                    "My World",
                    systemImage: "globe.asia.australia.fill"
                )
            }


            // MARK: - Trips

            TripsContainerView(
                context: context
            )
            .tabItem {
                Label(
                    "Trips",
                    systemImage: "airplane"
                )
            }
        }
    }
}


// MARK: - My World Container

private struct MyWorldContainerView: View {

    let context: NSManagedObjectContext

    var body: some View {

        let repository =
            CoreDataTravelRepository(
                context: context
            )

        let getAllPlacesUseCase =
            GetAllVisitedPlacesUseCase(
                repository: repository
            )

        let myWorldViewModel =
            MyWorldViewModel(
                getAllVisitedPlacesUseCase:
                    getAllPlacesUseCase
            )

        NavigationStack {

            MyWorldMapView(
                viewModel: myWorldViewModel
            )
        }
    }
}


// MARK: - Trips Container

private struct TripsContainerView: View {

    let context: NSManagedObjectContext

    @State private var showingAddTrip = false
    @State private var refreshID = UUID()

    var body: some View {

        let repository =
            CoreDataTravelRepository(
                context: context
            )

        let historyUseCase =
            GetTravelHistoryUseCase(
                repository: repository
            )

        let tripsViewModel =
            TripsViewModel(
                getTravelHistoryUseCase:
                    historyUseCase
            )

        NavigationStack {

            TripsView(
                viewModel: tripsViewModel,
                repository: repository
            )
            .id(refreshID)

            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {
                        showingAddTrip = true
                    } label: {

                        Image(
                            systemName: "plus"
                        )
                    }
                }
            }

            .sheet(
                isPresented: $showingAddTrip,
                onDismiss: {
                    refreshID = UUID()
                }
            ) {

                let recordUseCase =
                    RecordTripUseCase(
                        repository: repository
                    )

                let addTripViewModel =
                    AddTripViewModel(
                        recordTripUseCase:
                            recordUseCase
                    )

                AddTripView(
                    viewModel:
                        addTripViewModel
                )
            }
        }
    }
}
