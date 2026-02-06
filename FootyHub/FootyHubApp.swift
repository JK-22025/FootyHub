//
//  FootyHubApp.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-06.
//

import SwiftUI
import CoreData

@main
struct FootyHubApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
