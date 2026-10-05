//
//  MyWorldApp.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 28/9/2026.
//

import SwiftUI
import CoreData
import WidgetKit

@main
struct MyWorldApp: App {

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(
                context: persistenceController.container.viewContext
            )
            .onAppear {
                let repository = CoreDataTravelRepository(context: persistenceController.container.viewContext)
                let updateTravelSummaryUseCase = UpdateTravelSummaryUseCase(repository: repository)
                try? updateTravelSummaryUseCase.execute()
                WidgetCenter.shared.reloadTimelines(ofKind: "MyWorldWidget")
            }
        }
    }
}
