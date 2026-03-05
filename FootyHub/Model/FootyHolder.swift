//
//  FootyHolder.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-04.
//

import Foundation
import CoreData
import Combine

class FootyHolder: ObservableObject{
 
    
    //MARK: UI State
    @Published var selectedMatch: Match? = nil
    @Published var searchText: String = ""
    
    
    //MARK: data
    @Published var matches: [Match] = []
    @Published var players: [Player] = []
    @Published var leagues: [League] = []
    @Published var teams: [Team] = []
    @Published var stadiums: [Stadium] = []
    
    
    
    
    
    
 
    
    
    
    
    
    
    
    func saveContext(_ context: NSManagedObjectContext){
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
