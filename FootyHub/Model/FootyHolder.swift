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
    
    
    //MARK: functions
    
    init(_ context: NSManagedObjectContext){
        seedIFNeeded(context)
        refreshAll(context)
        
    }
    
    //MARK: Refresh methods
    
    //all
    func refreshAll(_ context: NSManagedObjectContext){
        refreshMatches(context)
        refreshPlayers(context)
        refreshLeagues(context)
        refreshTeams(context)
    }
    
    func refreshMatches(_ context: NSManagedObjectContext){
        matches = fetchMatches(context)
    }
    
    func refreshPlayers(_ context: NSManagedObjectContext){
        players = fetchPlayers(context)
    }
    
    func refreshLeagues(_ context: NSManagedObjectContext){
        leagues = fetchLeagues(context)
    }
    
    func refreshTeams(_ context: NSManagedObjectContext){
        teams = fetchTeams(context)
    }
    
    func refreshStadiums(_ context: NSManagedObjectContext){
        stadiums = fetchStadiums(context)
    }
    
    
    
    //MARK: fetch func
    func fetchMatches(_ context: NSManagedObjectContext)-> [Match]{
        do{
            return try context.fetch(matchesFetch())
            
            
        }catch{
            fatalError("Unresolved Error\(error)")
        }
    }
    func fetchPlayers(_ context: NSManagedObjectContext)-> [Player]{
        do{return try context.fetch(playersFetch())}
        catch{fatalError("Unresolved Error\(error)")}
    }
    
    
    func fetchLeagues(_ context: NSManagedObjectContext)-> [League]{
        do{return try context.fetch(leaguesFetch())}
        catch{fatalError("Unresolved Error\(error)")}
    }
    
    func fetchTeams(_ context: NSManagedObjectContext)-> [Team]{
        do{return try context.fetch(teamsFetch())}
        catch{fatalError("Unresolved Error\(error)")}
    }
    func fetchStadiums(_ context: NSManagedObjectContext)-> [Stadium]{
        do{return try context.fetch(stadiumsFetch())}
        catch{fatalError("Unresolved Error\(error)")}
    }
    
    //MARK: fetch requests
    
    func matchesFetch() -> NSFetchRequest<Match>{
        let request = Match.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Match.stadium, ascending: true),
            NSSortDescriptor(keyPath: \Match.createdAt, ascending: true)
            
        ]
        return request
    }
    
    func playersFetch() -> NSFetchRequest<Player>{
        let request = Player.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Player.name, ascending: true),
            NSSortDescriptor(keyPath: \Player.brithDate, ascending: true)
            
        ]
        return request
    }
    
    func leaguesFetch() -> NSFetchRequest<League>{
        let request = League.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \League.name, ascending: true)
            
            
        ]
        return request
    }
    
    
    
    
    func teamsFetch() -> NSFetchRequest<Team>{
        let request = Team.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Team.name, ascending: true),
            NSSortDescriptor(keyPath: \Team.foundedYear, ascending: true)
            
            
        ]
        return request
    }
    
    func stadiumsFetch() -> NSFetchRequest<Stadium>{
        let request = Stadium.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Stadium.name, ascending: true)
        ]
        return request
    }
    
    //MARK: Predicates (Filter + Search)
    
    private func playersPredicate() -> NSPredicate? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var parts: [NSPredicate] = []
        
        if let match = selectedMatch {
            parts.append(NSPredicate(format: "(stadium CONTAINS[cd] %@) OR (teams CONTAINS[cd] %@)", trimmed, trimmed))
        }
        
        if parts.isEmpty {return nil}
        if parts.count == 1 {return parts[0]}
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: parts)
    }
    
    // set the match
    
    func setMatch(_ match: Match?, _ context: NSManagedObjectContext){
        selectedMatch = match
        
        // refresh the list of products
        refreshMatches(context)
    }
    
    // search a team or league, player
    func setSearch(_ text: String, _ context: NSManagedObjectContext){
        searchText = text
        refreshTeams(context)
        refreshPlayers(context)
        refreshMatches(context)
    }
    
    
    
    
    
    
    
    
    
 
    
    
    
    private func seedIFNeeded(_ context: NSManagedObjectContext){
        let req = Match.fetchRequest()
        req.fetchLimit = 1
        let count = (try? context.count(for: req)) ?? 0
        guard count == 0 else {return}
        
        let leagues = Match(context: context)
        leagues.id = UUID()
        leagues.stadium = "Stadium"
        
        
    }
    
    
    
    func saveContext(_ context: NSManagedObjectContext){
        do {
            try context.save()
            
            //refresh context
            refreshAll(context)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
