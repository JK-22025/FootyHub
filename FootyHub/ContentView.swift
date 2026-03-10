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

   @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Match.createdAt, ascending: true)],
       animation: .default)
  private var items: FetchedResults<Match>

    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
            Text("Select an item")
        //}
   // }

        }
    }



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthService())
}
