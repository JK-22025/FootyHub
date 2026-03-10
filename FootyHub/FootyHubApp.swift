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
    let presistanceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthService()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        let ctx = presistanceController.container.viewContext
        WindowGroup {
            ContentView()
                .environmentObject(AuthService())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(FootyHolder(ctx))
        }
    }
}
