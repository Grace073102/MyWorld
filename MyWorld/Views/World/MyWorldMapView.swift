//
//  MyWorldMapView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 1/10/2026.
//

import SwiftUI
import MapKit

struct MyWorldMapView: View {

    @StateObject private var viewModel: MyWorldViewModel

    @State private var showingFullMap = false
    @State private var navigationPlaceID: UUID?
    @State private var sharedContent: String?
    @State private var sharedContentDate: Date?

    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 15, longitude: 20),
            span: MKCoordinateSpan(latitudeDelta: 140, longitudeDelta: 300)
        )
    )

    init(viewModel: MyWorldViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("My World")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Your journey so far")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ZStack(alignment: .bottomTrailing) {
                    Map(
                        position: $mapPosition,
                        interactionModes: [.pan, .zoom]
                    ) {
                        ForEach(viewModel.places) { place in
                            Annotation(
                                "",
                                coordinate: CLLocationCoordinate2D(
                                    latitude: place.latitude,
                                    longitude: place.longitude
                                ),
                                anchor: .bottom
                            ) {
                                Button {
                                    navigationPlaceID = place.id
                                } label: {
                                    PlaceMapMarker()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .mapStyle(
                        .standard(
                            elevation: .flat,
                            emphasis: .muted,
                            pointsOfInterest: .excludingAll
                        )
                    )
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                            .allowsHitTesting(false)
                    }

                    Button {
                        showingFullMap = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                            Text("Expand")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.70))
                        .clipShape(Capsule())
                    }
                    .padding(14)
                }

                HStack(spacing: 12) {
                    TravelStatCard(value: "\(tripCount)", title: "Trips", icon: "airplane")
                    TravelStatCard(value: "\(viewModel.places.count)", title: "Places", icon: "mappin.and.ellipse")
                }

                if let sharedContent {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")

                            Text("Shared with MyWorld")
                                .font(.headline)

                            Spacer()

                            Button {
                                SharedContentService.clear()
                                self.sharedContent = nil
                                sharedContentDate = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }

                        if let url = URL(string: sharedContent),
                           url.scheme != nil {
                            Link(destination: url) {
                                HStack {
                                    Image(systemName: "link")

                                    Text(sharedContent)
                                        .lineLimit(2)

                                    Spacer()

                                    Image(systemName: "arrow.up.right")
                                }
                            }
                        } else {
                            Text(sharedContent)
                                .foregroundStyle(.secondary)
                        }

                        if let sharedContentDate {
                            Text("Shared \(sharedContentDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Recent Places")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        if !viewModel.places.isEmpty {
                            Text("\(viewModel.places.count) total")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if viewModel.places.isEmpty {
                        ContentUnavailableView(
                            "No Places Yet",
                            systemImage: "mappin.and.ellipse",
                            description: Text("Places you visit will appear on your map.")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                    } else {
                        ForEach(recentPlaces) { place in
                            Button {
                                navigationPlaceID = place.id
                            } label: {
                                RecentPlaceRow(place: place)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.loadPlaces()
            sharedContent = SharedContentService.sharedContent
            sharedContentDate = SharedContentService.sharedContentDate
        }
        .fullScreenCover(isPresented: $showingFullMap) {
            FullWorldMapView(places: viewModel.places)
        }
        .navigationDestination(item: $navigationPlaceID) { placeID in
            if let place = viewModel.places.first(where: { $0.id == placeID }),
               let trip = viewModel.trip(for: place) {
                PlaceDetailView(
                    place: place,
                    trip: trip,
                    repository: viewModel.repositoryForView
                )
            } else {
                ContentUnavailableView(
                    "Place Not Found",
                    systemImage: "exclamationmark.triangle",
                    description: Text("The selected place could not be loaded.")
                )
            }
        }
    }

    private var recentPlaces: [VisitedPlaceModel] {
        Array(
            viewModel.places
                .sorted {
                    $0.visitedDate > $1.visitedDate
                }
                .prefix(5)
        )
    }

    private var tripCount: Int {
        Set(
            viewModel.places.map {
                $0.tripID
            }
        ).count
    }
}

private struct TravelStatCard: View {

    let value: String
    let title: String
    let icon: String

    private let gold = Color(red: 1.0, green: 0.72, blue: 0.18)

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(gold.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(gold)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct RecentPlaceRow: View {

    let place: VisitedPlaceModel

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.10))
                    .frame(width: 48, height: 48)

                Image(systemName: "mappin")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.red)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.headline)

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
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
