//
//  AddTripView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import SwiftUI

struct AddTripView: View {

    @StateObject private var viewModel: AddTripViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: AddTripViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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

                            if viewModel.country.isEmpty {
                                Text("Select")
                                    .foregroundStyle(.secondary)
                            } else {
                                Text(viewModel.country)
                                    .foregroundStyle(.secondary)
                            }
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
                            Image(systemName: "exclamationmark.triangle.fill")
                        }
                        .foregroundStyle(.red)
                    }
                }

                if viewModel.didSave {
                    Section {
                        Label(
                            "Trip saved successfully",
                            systemImage: "checkmark.circle.fill"
                        )
                        .foregroundStyle(.green)
                    }
                }

                Section {
                    Button {
                        viewModel.saveTrip()
                    } label: {
                        Text("Save Trip")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Add Trip")
            .onChange(of: viewModel.didSave) { _, didSave in
                if didSave {
                    dismiss()
                }
            }
        }
    }
}
