//
//  EditTripView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 30/9/2026.
//

import SwiftUI

struct EditTripView: View {

    @StateObject private var viewModel: EditTripViewModel
    @Environment(\.dismiss) private var dismiss
    
    let onSave: (TripModel) -> Void

    init(
        viewModel: EditTripViewModel,
        onSave: @escaping (TripModel) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {

                Section("Trip Information") {

                    TextField(
                        "Trip name",
                        text: $viewModel.name
                    )

                    NavigationLink {
                        CountryPickerView(
                            selectedCountry: $viewModel.country,
                            selectedCountryCode: $viewModel.countryCode
                        )
                    } label: {
                        HStack {

                            Text("Country")

                            Spacer()

                            Text(viewModel.country)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Dates") {

                    DatePicker(
                        "Start Date",
                        selection: $viewModel.startDate,
                        displayedComponents: .date
                    )

                    DatePicker(
                        "End Date",
                        selection: $viewModel.endDate,
                        displayedComponents: .date
                    )
                }

                Section("Notes") {

                    TextField(
                        "Notes",
                        text: $viewModel.notes,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }

                if let errorMessage = viewModel.errorMessage {

                    Section {
                        Label {
                            Text(errorMessage)
                        } icon: {
                            Image(
                                systemName:
                                    "exclamationmark.triangle.fill"
                            )
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Edit Trip")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(
                    placement: .confirmationAction
                ) {
                    Button("Save") {
                        viewModel.updateTrip()
                    }
                    .fontWeight(.semibold)
                }
            }

            .onChange(of: viewModel.didSave) { _, didSave in
                if didSave {
                    onSave(viewModel.updatedTrip)
                    dismiss()
                }
            }
        }
    }
}
