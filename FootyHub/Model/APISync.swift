//
//  APISync.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-04.
//

import Foundation
import CoreData
final class APISync{
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // fetch matches for a day
    func fetchMatchesForDay(
        date: Date,
        calendar: Calendar,
        context: NSManagedObjectContext,
        onApplyingRemote: @escaping (Bool) -> Void,
        onRemoteApplied: @escaping () -> Void
        
    ){
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        var components = URLComponents(
            url: baseURL.appendingPathComponent("matches"),
            resolvingAgainstBaseURL: false
        )!
        
        components.queryItems = [
            URLQueryItem(name: "start", value: Self.backendDateFormatter.string(from: start)),
            URLQueryItem(name: "end", value: Self.backendDateFormatter.string(from: end))
            
        ]
        
        guard let url = components.url else{
            print("Invalid fetch URL")
            return
        }
        
        print("FETCH URL:", url.absoluteString)
        
        DispatchQueue.main.async {
            onApplyingRemote(true)
        }
        
        let match = session.dataTask(with: url) { data, response, error in
            if let error{
                print("GET /matches error:", error)
                DispatchQueue.main.async {
                    onApplyingRemote(false)
                }
                return
            }
            
            guard(200..<300).contains(httpResponse.statusCode) else {
                
            }
        }
        
    }
    
    
    // merge remote --> coredata
    
    private func mergeRemoteMatches(_ remoteMatches: [MatchDTO], into context: NSManagedObjectContext){
        let request: NSFetchRequest<Match> = Match.fetchRequest()
        let localMatches = (try? context.fetch(request)) ?? []
        
        
        var groupByID: [String: [Match]] = [:]
        for match in localMatches{
            guard let id = match.id?.uuidString else { continue }
            groupByID[id, default: []].append(match)
        }
        
        var localByID: [String: Match] = [:]
        for (id, matches) in groupByID{
            guard let keeper = matches.first else {continue}
            localByID[id] = keeper
            
            if matches.count > 1{
                print("Removing duplicate local CoreData items for id", id)
                for duplicate in matches.dropFirst(){
                    context.delete(duplicate)
                }
            }
        }
        
        for dto in remoteMatches{
            let match = localByID[dto.id] ?? Match(context: context)
            match.id = UUID(uuidString: dto.id)
            match.stadium = dto.stadium
            match.createdAt = dto.createdAt
            match.homeScore = dto.homeScore
            match.awayScore = dto.awayScore
        }
        
        
        
    }
    
    
    private func mergeRemoteLeagues(_ remoteLeagues: [LeagueDTO], into context: NSManagedObjectContext){
        let request: NSFetchRequest<League> = League.fetchRequest()
        let localLeagues = (try? context.fetch(request)) ?? []
        
        
        var groupByID: [String: [League]] = [:]
        for league in localLeagues{
            guard let id = league.id?.uuidString else { continue }
            groupByID[id, default: []].append(league)
        }
        
        var localByID: [String: League] = [:]
        for (id, leagues) in groupByID{
            guard let keeper = leagues.first else {continue}
            localByID[id] = keeper
            
            if leagues.count > 1{
                print("Removing duplicate local CoreData items for id", id)
                for duplicate in leagues.dropFirst(){
                    context.delete(duplicate)
                }
            }
        }
        
        
        for dto in remoteLeagues{
            let league = localByID[dto.id] ?? League(context: context)
            league.id = UUID(uuidString:dto.id)
            league.name = dto.name
            league.country = dto.country
            
        }
        
        
        
    }
    
    
    private func mergeRemotePlayers(_ remotePlayers: [PlayersDTO], into context: NSManagedObjectContext){
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        let localPlayers = (try? context.fetch(request)) ?? []
        
        
        var groupByID: [String: [Player]] = [:]
        for player in localPlayers{
            guard let id = player.id?.uuidString else { continue }
            groupByID[id, default: []].append(player)
        }
        
        var localByID: [String: Player] = [:]
        for (id, players) in groupByID{
            guard let keeper = players.first else {continue}
            localByID[id] = keeper
            
            if players.count > 1{
                print("Removing duplicate local CoreData items for id", id)
                for duplicate in players.dropFirst(){
                    context.delete(duplicate)
                }
            }
        }
        
        for dto in remotePlayers{
            let player = localByID[dto.id] ?? Player(context: context)
            player.id = UUID(uuidString:dto.id)
            player.name = dto.name
            player.brithDate = dto.brithDate
            player.height = dto.height
            player.weight = dto.weight
            player.nationality = dto.nationality
            player.photoURL = dto.photoURL
            player.rating = dto.rating
            player.position = dto.position
            player.stats = dto.stats
            player.team = dto.team
            
        }
        
        
        
    }
    
    private func mergeRemoteTeams(_ remoteTeams: [TeamDTO], into context: NSManagedObjectContext){
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        let localTeams = (try? context.fetch(request)) ?? []
        
        
        var groupByID: [String: [Team]] = [:]
        for team in localTeams{
            guard let id = team.id?.uuidString else { continue }
            groupByID[id, default: []].append(team)
        }
        
        var localByID: [String: Team] = [:]
        for (id, teams) in groupByID{
            guard let keeper = teams.first else {continue}
            localByID[id] = keeper
            
            if teams.count > 1{
                print("Removing duplicate local CoreData items for id", id)
                for duplicate in teams.dropFirst(){
                    context.delete(duplicate)
                }
            }
        }
        
        for dto in remoteTeams{
            let team = localByID[dto.id] ?? Team(context: context)
            team.id = UUID(uuidString:dto.id)
            team.name = dto.name
            team.descrption = dto.description
            team.coach = dto.coach
            team.foundedYear = dto.foundedYear
            team.logoURL = dto.logoURL
            team.stats = dto.stats
            
        }
        
        
        
    }
    
    private func mergeRemotestadiums(_ remoteStadiums: [StadiumDTO], into context: NSManagedObjectContext){
        let request: NSFetchRequest<Stadium> = Stadium.fetchRequest()
        let localStadium = (try? context.fetch(request)) ?? []
        
        
        var groupByID: [String: [Stadium]] = [:]
        for stadium in localStadium{
            guard let id = stadium.id?.uuidString else { continue }
            groupByID[id, default: []].append(stadium)
        }
        
        var localByID: [String: Stadium] = [:]
        for (id, stadiums) in groupByID{
            guard let keeper = stadiums.first else {continue}
            localByID[id] = keeper
            
            if stadiums.count > 1{
                print("Removing duplicate local CoreData items for id", id)
                for duplicate in stadiums.dropFirst(){
                    context.delete(duplicate)
                }
            }
        }
        
        for dto in remoteStadiums{
            let stadiums = localByID[dto.id] ?? Stadium(context: context)
            stadiums.id = UUID(uuidString: dto.id)
            stadiums.name = dto.name
            stadiums.city = dto.city
            stadiums.country = dto.country
            stadiums.imageURL = dto.imageURL
            stadiums.team = dto.team
            stadiums.capacity = dto.capacity
        }
        
        
        
    }
    
    
    
    private static let backendDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
        
    }()
    
    private static let backendDateFormatterWithFractional: DateFormatter = {
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
           formatter.timeZone = TimeZone.current
           return formatter
       }()
    
}

