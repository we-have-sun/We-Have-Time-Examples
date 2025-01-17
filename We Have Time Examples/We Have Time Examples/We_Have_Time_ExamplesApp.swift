//
//  We_Have_Time_ExamplesApp.swift
//  We Have Time Examples
//
//  Created by Natalia Terlecka on 18/11/2024.
//

import SwiftUI
import SwiftData
import WeHaveTime

@main
struct We_Have_Time_ExamplesApp: App {
    let container: ModelContainer

    init() {
        let databaseManager = DatabaseManager()
        container = databaseManager.setupContainer()
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("List of task", systemImage: "list.triangle")
                    }
                Timers()
                    .tabItem {
                        Label("Timer", systemImage: "timer")
                    }
            }
        }
        .modelContainer(container)
    }
}
