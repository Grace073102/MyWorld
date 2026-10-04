//
//  CountryPickerView.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import SwiftUI

struct CountryPickerView: View {

    @Environment(\.dismiss) private var dismiss

    @Binding var selectedCountry: String
    @Binding var selectedCountryCode: String

    @State private var searchText = ""

    private var filteredCountries: [Country] {
        if searchText.isEmpty {
            return Country.allCountries
        }

        return Country.allCountries.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List(filteredCountries) { country in

            Button {
                selectedCountry = country.name
                selectedCountryCode = country.code
                dismiss()
            } label: {
                HStack {
                    Text(flag(for: country.code))

                    Text(country.name)
                        .foregroundStyle(.primary)

                    Spacer()

                    Text(country.code)
                        .foregroundStyle(.secondary)

                    if selectedCountryCode == country.code {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationTitle("Select Country")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search countries")
    }

    private func flag(for countryCode: String) -> String {
        let code = countryCode.uppercased()

        guard code.count == 2,
              code.allSatisfy({ $0.isLetter }) else {
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
