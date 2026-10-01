//
//  FullWorldMapView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 2/10/2026.
//

import SwiftUI
import MapKit

struct FullWorldMapView: View {

    let places: [VisitedPlaceModel]

    @Environment(\.dismiss)
    private var dismiss

    @State private var selectedPlace: VisitedPlaceModel?

    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 15,
                longitude: 20
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 140,
                longitudeDelta: 300
            )
        )
    )

    var body: some View {

        ZStack {

            // MARK: - Apple Map

            Map(
                position: $mapPosition,
                interactionModes: [
                    .pan,
                    .zoom
                ]
            ) {

                ForEach(places) { place in

                    Annotation(
                        "",
                        coordinate: CLLocationCoordinate2D(
                            latitude: place.latitude,
                            longitude: place.longitude
                        ),
                        anchor: .bottom
                    ) {

                        Button {

                            selectedPlace = place

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
                    pointsOfInterest:
                        .excludingAll
                )
            )
            .ignoresSafeArea()


            // MARK: - Overlay Controls

            VStack {

                // MARK: - Top Bar

                HStack {

                    // Close Button

                    Button {

                        dismiss()

                    } label: {

                        Image(
                            systemName: "xmark"
                        )
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(
                            width: 44,
                            height: 44
                        )
                        .background(
                            Color.black.opacity(0.70)
                        )
                        .clipShape(
                            Circle()
                        )
                    }


                    Spacer()


                    // MARK: - Title

                    VStack(
                        alignment: .trailing,
                        spacing: 2
                    ) {

                        Text("My World")
                            .font(.headline)
                            .foregroundStyle(.white)

                        if !places.isEmpty {

                            Text(
                                "\(places.count) places explored"
                            )
                            .font(.caption)
                            .foregroundStyle(
                                Color.white.opacity(0.70)
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        Color.black.opacity(0.70)
                    )
                    .clipShape(
                        Capsule()
                    )
                }


                Spacer()


                // MARK: - Bottom Information

                if !places.isEmpty {

                    HStack(spacing: 8) {

                        Image(
                            systemName: "mappin"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.red)


                        Text(
                            "\(places.count) places explored"
                        )
                        .foregroundStyle(.white)
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background(
                        Color.black.opacity(0.70)
                    )
                    .clipShape(
                        Capsule()
                    )
                }
            }
            .padding()
        }

        // MARK: - Selected Place Sheet

        .sheet(
            item: $selectedPlace
        ) { place in

            PlaceDetailSheet(
                place: place
            )
            .presentationDetents([
                .height(240)
            ])
            .presentationDragIndicator(
                .visible
            )
        }
    }
}


// MARK: - Red Drop Pin

struct PlaceMapMarker: View {

    var body: some View {

        Image(
            systemName: "mappin"
        )
        .font(
            .system(
                size: 30,
                weight: .semibold
            )
        )
        .foregroundStyle(.red)
        .shadow(
            color: .black.opacity(0.25),
            radius: 2,
            y: 2
        )
    }
}


// MARK: - Place Detail Sheet

struct PlaceDetailSheet: View {

    let place: VisitedPlaceModel

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            // MARK: - Place Header

            HStack(spacing: 14) {

                ZStack {

                    Circle()
                        .fill(
                            Color.red.opacity(0.10)
                        )
                        .frame(
                            width: 52,
                            height: 52
                        )

                    Image(
                        systemName:
                            "mappin.circle.fill"
                    )
                    .font(
                        .system(size: 30)
                    )
                    .foregroundStyle(.red)
                }


                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text(place.name)
                        .font(.title3)
                        .fontWeight(.bold)

                    if !place.city.isEmpty {

                        Text(place.city)
                            .font(.subheadline)
                            .foregroundStyle(
                                .secondary
                            )
                    }
                }


                Spacer()
            }


            Divider()


            // MARK: - Visited Date

            Label {

                Text(
                    place.visitedDate.formatted(
                        date: .long,
                        time: .omitted
                    )
                )

            } icon: {

                Image(
                    systemName: "calendar"
                )
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)


            // MARK: - Notes

            if !place.notes
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .isEmpty {

                Label {

                    Text(place.notes)
                        .lineLimit(2)

                } icon: {

                    Image(
                        systemName: "note.text"
                    )
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }


            Spacer()
        }
        .padding()
    }
}
