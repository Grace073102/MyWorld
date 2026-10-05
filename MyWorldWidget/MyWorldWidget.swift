//
//  MyWorldWidget.swift
//  MyWorldWidget
//
//  Created by Grace Chi Yen Chong on 5/10/2026.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tripCount: 0, countryCount: 0, placeCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = loadEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadEntry() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: "group.com.gracechong.MyWorld")
        return SimpleEntry(
            date: Date(),
            tripCount: defaults?.integer(forKey: "tripCount") ?? 0,
            countryCount: defaults?.integer(forKey: "countryCount") ?? 0,
            placeCount: defaults?.integer(forKey: "placeCount") ?? 0
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let tripCount: Int
    let countryCount: Int
    let placeCount: Int
}

struct MyWorldWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "globe.asia.australia.fill")
                Text("My World")
                    .font(.headline)
            }

            Spacer()

            Label("\(entry.countryCount) Countries", systemImage: "globe")
            Label("\(entry.tripCount) Trips", systemImage: "airplane")
            Label("\(entry.placeCount) Places", systemImage: "mappin.and.ellipse")

            Spacer()
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MyWorldWidget: Widget {
    let kind: String = "MyWorldWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyWorldWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My World")
        .description("See your travel statistics at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
