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
    
    // fetch matches, leagues and players and teams und shtaidum
    
    // update
    
    // delete
    
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
    
    
    
    
    // create request
    // MARK: - Create request builders
    private func makeCreateRequest(from match: Match) -> CreateMatchRequest? {
        // All attributes optional; add minimal requirements if your backend needs them.
        let stadium = match.stadium
        let createdAt = match.createdAt
        let homeScore = match.homeScore
        let awayScore = match.awayScore

        // TODO: Construct and return a CreateMatchRequest using these values once the DTO exists.
        // Example:
        // return CreateMatchRequest(
        //     stadium: stadium,
        //     createdAt: createdAt.map { Self.backendDateFormatter.string(from: $0) },
        //     homeScore: homeScore,
        //     awayScore: awayScore
        // )

        _ = stadium
        _ = createdAt
        _ = homeScore
        _ = awayScore
        return nil
    }

    private func makeCreateRequest(from league: League) -> CreateLeagueRequest? {
        let name = league.name
        let country = league.country
        // Add other optional fields as needed

        // TODO: Construct and return a CreateLeagueRequest once the DTO exists.
        // Example:
        // return CreateLeagueRequest(
        //     name: name,
        //     country: country
        // )

        _ = name
        _ = country
        return nil
    }

    private func makeCreateRequest(from team: Team) -> CreateTeamRequest? {
        let coach = team.coach
        let desc = team.description
        let foundedYear = team.foundedYear
        let leagues = team.leagues
        let logoUrl = team.logoURL
        let name = team.name
        let stadium = team.stadium
        let stats = team.stats

        // TODO: Construct and return a CreateTeamRequest once the DTO exists.
        // Example:
        // return CreateTeamRequest(
        //     coach: coach,
        //     description: desc,
        //     foundedYear: foundedYear,
        //     leagues: leagues,
        //     logoUrl: logoUrl,
        //     name: name,
        //     stadium: stadium,
        //     stats: stats
        // )

        _ = coach
        _ = desc
        _ = foundedYear
        _ = leagues
        _ = logoUrl
        _ = name
        _ = stadium
        _ = stats
        return nil
    }

    private func makeCreateRequest(from player: Player) -> CreatePlayersRequest? {
        let name = player.name
        let nationality = player.nationality
        let position = player.position
        let team = player.team
        let birthDate = player.brithDate
        let photoURL = player.photoURL
        let height = player.height
        let weight = player.weight
        let rating = player.rating
        let stats = player.stats

        // TODO: Construct and return a CreatePlayerRequest once the DTO exists.
        // Example:
        // return CreatePlayerRequest(
        //     id: id?.uuidString,
        //     name: name,
        //     nationality: nationality,
        //     position: position,
        //     team: team,
        //     birthDate: birthDate.map { Self.backendDateFormatter.string(from: $0) },
        //     height: height,
        //     weight: weight,
        //     rating: rating,
        //     stats: stats,
        //     photoURL: photoURL
        // )

        _ = name
        _ = nationality
        _ = position
        _ = team
        _ = birthDate
        _ = photoURL
        _ = height
        _ = weight
        _ = rating
        _ = stats
        return nil
    }
    private func makeCreateRequest(from stadium: Stadium) -> CreateStadiumRequest? {
        
        guard
            let name = stadium.name,
            let country = stadium.country,
            let city = stadium.city,
            let team = stadium.team
        else {
            return nil
        }

        // Other optional attributes
        let capacity = stadium.capacity
        let id = stadium.id

        
        _ = name
        _ = team
        _ = capacity
        _ = id
        return nil
        
    }
   
    
    
    //update request
    
    private func makeUpdateRequest(from match: Match) -> UpdateMatchRequest? {
        // All attributes are optional in your model. Choose minimal requirements if needed.
        // Example: require stadium and createdAt if your backend needs them, otherwise remove this guard.
        // guard let stadium = match.stadium, let createdAt = match.createdAt else { return nil }

        let stadium = match.stadium
        let createdAt = match.createdAt
        let homeScore = match.homeScore
        let awayScore = match.awayScore

        // TODO: Construct and return an UpdateMatchRequest using the values once the DTO exists.
        // Example:
        // return UpdateMatchRequest(
        //     id: match.objectID.uriRepresentation().absoluteString,
        //     stadium: stadium,
        //     createdAt: createdAt.map { Self.backendDateFormatter.string(from: $0) },
        //     homeScore: homeScore,
        //     awayScore: awayScore
        // )

        _ = stadium
        _ = createdAt
        _ = homeScore
        _ = awayScore
        return nil
    }

    private func makeUpdateRequest(from league: League) -> UpdateLeagueRequest? {
        // Unwrap only optional fields. Adjust based on your League model.
        guard
            let name = league.name,
            let country = league.country
        else {
            return nil
        }

        // Read non-optional fields directly if any (e.g., identifiers or numeric properties)
        
        
        // TODO: Construct and return an UpdateLeagueRequest using the unwrapped values.
        // Example:
        // return UpdateLeagueRequest(
        //     id: league.objectID.uriRepresentation().absoluteString,
        //     name: name,
        //     country: country,
        //     foundedYear: foundedYear
        // )

        _ = name
        _ = country
        
        return nil
    }

    private func makeUpdateRequest(from team: Team) -> UpdateTeamRequest? {
        // All attributes are optional in your model. Add a minimal guard if your backend requires certain fields.
        // Example minimal requirements (uncomment if needed):
        // guard let name = team.name else { return nil }

        let coach = team.coach
        let desc = team.description
        let foundedYear = team.foundedYear
        let leagues = team.leagues
        let logoUrl = team.logoURL
        let name = team.name
        let stadium = team.stadium
        let stats = team.stats

        // TODO: Construct and return an UpdateTeamRequest using these values once the DTO exists.
        // Example:
        // return UpdateTeamRequest(
        //     id: team.objectID.uriRepresentation().absoluteString,
        //     coach: coach,
        //     description: desc,
        //     foundedYear: foundedYear,
        //     leagues: leagues,
        //     logoUrl: logoUrl,
        //     name: name,
        //     stadium: stadium,
        //     stats: stats
        // )

        _ = coach
        _ = desc
        _ = foundedYear
        _ = leagues
        _ = logoUrl
        _ = name
        _ = stadium
        _ = stats
        return nil
    }
    

    private func makeUpdateRequest(from player: Player) -> UpdatePlayersRequest? {
        // All attributes are optional in your model. Choose a minimal set of required fields for an update.
        // Here we require `name`, `nationality`, `position`, and `team`. Adjust as needed.
        guard
            let name = player.name,
            let nationality = player.nationality,
            let position = player.position,
            let team = player.team
        else {
            return nil
        }

        // Other optional attributes
        let birthDate = player.brithDate
        let photoURL = player.photoURL
        let height = player.height
        let weight = player.weight
        let rating = player.rating
        let stats = player.stats
        let id = player.id

        // TODO: Construct and return an UpdatePlayerRequest using these values once the DTO exists.
        // Example (define UpdatePlayerRequest to match your backend contract):
        // return UpdatePlayerRequest(
        //     id: id?.uuidString,
        //     name: name,
        //     nationality: nationality,
        //     position: position,
        //     team: team,
        //     birthDate: birthDate.map { Self.backendDateFormatter.string(from: $0) },
        //     height: height,
        //     weight: weight,
        //     rating: rating,
        //     stats: stats,
        //     photoURL: photoURL
        // )

        // Temporary placeholders so this compiles until UpdatePlayerRequest is defined.
        _ = name
        _ = nationality
        _ = position
        _ = team
        _ = birthDate
        _ = photoURL
        _ = height
        _ = weight
        _ = rating
        _ = stats
        _ = id
        return nil
    }
    
    
    
    private func makeUpdateRequest(from stadium: Stadium) -> UpdateStadiumRequest? {
        
        guard
            let name = stadium.name,
            let country = stadium.country,
            let city = stadium.city,
            let team = stadium.team
        else {
            return nil
        }

        // Other optional attributes
        let capacity = stadium.capacity
        let id = stadium.id

        
        _ = name
        _ = team
        _ = capacity
        _ = id
        return nil
        
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

