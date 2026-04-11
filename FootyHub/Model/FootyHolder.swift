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
    @Published var selectedPlayer: Player? = nil
    @Published var selectedTeam: Team? = nil
    @Published var selectedLeague: League? = nil
    @Published var searchText: String = ""
    @Published var selectedUser : User? = nil
    @Published var isSettingsPresented: Bool = false
    
    
    //MARK: data
    @Published var matches: [Match] = []
    @Published var players: [Player] = []
    @Published var leagues: [League] = []
    @Published var teams: [Team] = []
    @Published var stadiums: [Stadium] = []
    @Published var users: [User] = []
    @Published var settings: [Settings] = []
    
    let calendar: Calendar = Calendar.current
    
    private let sync = FirebaseSync(collectionPath: "matches")
    
    // prevent the echo loop -> remote-> coredata --> saveContext ---> remote
    private var isApplyingRemoteChanges: Bool = false
    
    
    //MARK: functions
    
    init(_ context: NSManagedObjectContext){
        // 1)coredata changes
        seedIFNeeded(context)
        seedPlayersIfNeeded(context)
        seedStadiumsIfNeeded(context)
        refreshAll(context)
        
        //2) firebase listner
        sync.startListeningForDay(
            date: Date(),
            calendar: Calendar.current,
            context: context) { [weak self] applying in
                DispatchQueue.main.async {
                    self?.isApplyingRemoteChanges = applying
                }
            } onRemoteApplied: {
                [weak self] in
                DispatchQueue.main.async {
                    guard let self else {return}
                    self.refreshAll(context)
                }
            }

        
    }
    
    //MARK: Refresh methods
    
    //all
    func refreshAll(_ context: NSManagedObjectContext){
        refreshMatches(context)
        refreshPlayers(context)
        refreshLeagues(context)
        refreshTeams(context)
        refreshStadiums(context)
        refreshSettings(context)
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
    
    func refreshUsers(_ context: NSManagedObjectContext){
        users = fetchUsers(context)
    }
    
    func refreshSettings(_ context: NSManagedObjectContext){
        settings = fetchSettings(context)
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
    
    func fetchUsers(_ context: NSManagedObjectContext)-> [User]{
        do{return try context.fetch(usersFetch())}
        catch{fatalError("Unresolved Error\(error)")}
    }
    
    func fetchSettings(_ context: NSManagedObjectContext)-> [Settings]{
        do{return try context.fetch(settingsFetch())}
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
        request.predicate = playersPredicate()
        return request
    }
    
    func leaguesFetch() -> NSFetchRequest<League>{
        let request = League.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \League.name, ascending: true)
            
            
        ]
        request.predicate = LeaguePredicate()
        return request
    }
    
    
    
    
    func teamsFetch() -> NSFetchRequest<Team>{
        let request = Team.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Team.name, ascending: true),
            NSSortDescriptor(keyPath: \Team.foundedYear, ascending: true)
            
            
        ]
        request.predicate = teamsPredicate()
        return request
    }
    
    func stadiumsFetch() -> NSFetchRequest<Stadium>{
        let request = Stadium.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Stadium.name, ascending: true)
        ]
        return request
    }
    func usersFetch() -> NSFetchRequest<User>{
        let request = User.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \User.displayName, ascending: true)
        ]
        return request
    }
    
    func settingsFetch() -> NSFetchRequest<Settings>{
        let request = Settings.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Settings.profile, ascending: true)
        ]
        return request
    }
    
    //MARK: Predicates (Filter + Search)
    
    private func playersPredicate() -> NSPredicate? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return NSPredicate(format: "(name CONTAINS[cd] %@) OR (nationality CONTAINS[cd] %@)", trimmed, trimmed)
    }
    
    private func teamsPredicate() -> NSPredicate? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return NSPredicate(format: "(name CONTAINS[cd] %@) OR (coach CONTAINS[cd] %@)", trimmed, trimmed)
    }
    
    private func LeaguePredicate() -> NSPredicate? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return NSPredicate(format: "(name CONTAINS[cd] %@) OR (country CONTAINS[cd] %@)", trimmed, trimmed)
    }
    
    

    
    
    // set the match
    
    func setMatch(_ match: Match?, _ context: NSManagedObjectContext){
        selectedMatch = match
        
        // refresh the list of products
        refreshMatches(context)
    }
    
    func setPlayer(_ player: Player?, _ context: NSManagedObjectContext){
        selectedPlayer = player
        refreshPlayers(context)
    }
    func setTeam(_ team: Team?, _ context: NSManagedObjectContext){
        selectedTeam = team
        refreshTeams(context)
    }
    
    func setLeague(_ league: League?, _ context: NSManagedObjectContext){
        selectedLeague = league
        refreshLeagues(context)
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
        let match = Match(context: context)
        match.id = UUID()
        match.stadium = "Stadium"
        match.createdAt = Date()
        match.homeScore = 0
        match.awayScore = 0

        try? context.save()
        
        
    }

    private func seedPlayersIfNeeded(_ context: NSManagedObjectContext){
        let req = Player.fetchRequest()
        req.fetchLimit = 1
        let count = (try? context.count(for: req)) ?? 0
        guard count == 0 else { return }

        func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
            var comps = DateComponents()
            comps.year = year
            comps.month = month
            comps.day = day
            return calendar.date(from: comps) ?? Date()
        }

        let p1 = Player(context: context)
        p1.name = "Lionel Messi"
        p1.nationality = "Argentina"
        p1.brithDate = date(1987, 6, 24)

        let p2 = Player(context: context)
        p2.name = "Cristiano Ronaldo"
        p2.nationality = "Portugal"
        p2.brithDate = date(1985, 2, 5)

        let p3 = Player(context: context)
        p3.name = "Mohamed Salah"
        p3.nationality = "Egypt"
        p3.brithDate = date(1992, 6, 15)

        let p4 = Player(context: context)
        p4.name = "Kylian Mbappé"
        p4.nationality = "France"
        p4.brithDate = date(1998, 12, 20)

        let p5 = Player(context: context)
        p5.name = "Kevin De Bruyne"
        p5.nationality = "Belgium"
        p5.brithDate = date(1991, 6, 28)

        try? context.save()
    }

    private func seedStadiumsIfNeeded(_ context: NSManagedObjectContext){
        let req = Stadium.fetchRequest()
        req.fetchLimit = 1
        let count = (try? context.count(for: req)) ?? 0
        guard count == 0 else { return }

        let s1 = Stadium(context: context)
        s1.name = "Anfield"
        s1.city = "Liverpool"
        s1.country = "England"
        s1.team = "Liverpool FC"
        s1.imageURL = "soccerball"

        let s2 = Stadium(context: context)
        s2.name = "Camp Nou"
        s2.city = "Barcelona"
        s2.country = "Spain"
        s2.team = "FC Barcelona"
        s2.imageURL = "soccerball"

        let s3 = Stadium(context: context)
        s3.name = "San Siro"
        s3.city = "Milan"
        s3.country = "Italy"
        s3.team = "AC Milan / Inter Milan"
        s3.imageURL = "soccerball"

        let s4 = Stadium(context: context)
        s4.name = "Emirates Stadium"
        s4.city = "London"
        s4.country = "England"
        s4.team = "Arsenal FC"
        s4.imageURL = "soccerball"

        let s5 = Stadium(context: context)
        s5.name = "Saputo Stadium"
        s5.city = "Montreal"
        s5.country = "Canada"
        s5.team = "CF Montréal"
        s5.imageURL = "soccerball"

        try? context.save()
    }
    
    
    
    func moveDate(days: Int, _ context: NSManagedObjectContext){
        let newDate = calendar.date(byAdding: .day, value: days, to: Date()) ?? Date()
        sync.StopListening()
        sync.startListeningForDay(
            date: newDate,
            calendar: calendar,
            context: context,
            onApplyingRemote: { [weak self] applying in
                DispatchQueue.main.async { self?.isApplyingRemoteChanges = applying }
            },
            onRemoteApplied: { [weak self] in
                DispatchQueue.main.async { self?.refreshAll(context) }
            }
        )
    }
    private func ensureStableIDs(_ context: NSManagedObjectContext){
        for obj in context.updatedObjects{
            guard let m = obj as? Match else {continue}
            if m.id == nil {
                m.id = UUID()
            }
            if m.createdAt == nil {
                m.createdAt = Date()
            }
        }
    }
    
    
    
    func saveContext(_ context: NSManagedObjectContext){
        ensureStableIDs(context)
        
        let updated = context.updatedObjects.compactMap{$0 as? User}
        let inserted = context.insertedObjects.compactMap{$0 as? User}
        let deleted = context.deletedObjects.compactMap{$0 as? User}
        
        let deletedIDs: [UUID] = deleted.compactMap{$0.id}
        
        do {
            try context.save()
            
            //refresh context
            refreshAll(context)
            deletedIDs.forEach{sync.pushDelete(userID: $0)}
            
            guard !isApplyingRemoteChanges else {return}
            
            inserted.forEach {sync.pushUpsert(user: $0)}
            updated.forEach{sync.pushUpsert(user: $0)}
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

