//
//  SystemStatsApp.swift
//  SystemStats
//
//  Created by Zach Nagengast on 11/9/23.
//

import SwiftUI
import SwiftData

@main
struct SystemStatsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            StatisticsView()
        }
        .modelContainer(sharedModelContainer)
    }
}
