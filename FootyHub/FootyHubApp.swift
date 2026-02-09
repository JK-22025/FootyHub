//
//  FootyHubApp.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-06.
//

import SwiftUI
import CoreData
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct FootyHubApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthManager()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthManager())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
