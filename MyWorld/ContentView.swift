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

        let repository = CoreDataTravelRepository(
            context: context
        )

        let useCase = RecordTripUseCase(
            repository: repository
        )

        let viewModel = AddTripViewModel(
            recordTripUseCase: useCase
        )

        AddTripView(
            viewModel: viewModel
        )
    }
}
