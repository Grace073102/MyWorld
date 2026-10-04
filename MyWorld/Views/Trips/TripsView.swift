//
//  TripsView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import SwiftUI

struct TripsView: View {

    @StateObject private var viewModel: TripsViewModel
    private let repository: TravelRepositoryProtocol

    init(viewModel: TripsViewModel, repository: TravelRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.repository = repository
    }

    var body: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Unable to Load Trips",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
            } else if viewModel.trips.isEmpty {
                ContentUnavailableView(
                    "No Trips Yet",
                    systemImage: "airplane",
                    description: Text("Add your first trip to start building your travel history.")
                )

            } else {
                List(viewModel.trips) { trip in
                    NavigationLink {
                        TripDetailView(
                            trip: trip,
                            repository: repository
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(flag(for: trip.countryCode))
                                    .font(.title2)
                                
                                Text(trip.name)
                                    .font(.headline)
                            }
                            
                            Text(trip.country)
                                .foregroundStyle(.secondary)
                            
                            Label {
                                Text("\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) – \(trip.endDate.formatted(date: .abbreviated, time: .omitted))"
                                )
                            } icon: {
                                Image(systemName: "calendar")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("My Trips")
        .onAppear {
            viewModel.loadTrips()
        }
    }

    private func flag(for countryCode: String) -> String {
        let code = countryCode.uppercased()
        guard code.count == 2 else {
            return "🌍"
        }

        return code.unicodeScalars
            .compactMap {
                UnicodeScalar(127397 + $0.value)
            }
            .map(String.init)
            .joined()
    }
}
