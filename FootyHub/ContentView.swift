//
//  ContentView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-06.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @EnvironmentObject var authManager: AuthService
    @Environment(\.managedObjectContext) private var viewContext

//   @FetchRequest(
//    sortDescriptors: [NSSortDescriptor(keyPath: \Match.createdAt, ascending: true)],
//       animation: .default)
//  private var items: FetchedResults<Match>

    var body: some View {
        TabView{
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        
        
        TabView{
            
        }


        }
    }



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthService())
}
