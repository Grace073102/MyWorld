//
//  Country.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 29/9/2026.
//

import Foundation

struct Country: Identifiable, Hashable {
    let code: String
    let name: String

    var id: String {
        code
    }

    static let allCountries: [Country] = {
        Locale.Region.isoRegions
            .compactMap { region in

                let code = region.identifier

                // Only keep 2-letter country codes
                guard code.count == 2,
                      code.allSatisfy({ $0.isLetter }),
                      let name = Locale.current.localizedString(
                        forRegionCode: code
                      ) else {
                    return nil
                }

                return Country(
                    code: code,
                    name: name
                )
            }
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name)
                    == .orderedAscending
            }
    }()
}
