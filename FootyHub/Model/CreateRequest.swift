//
//  CreateRequest.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-06.
//

import Foundation

struct CreateMatchRequest: Codable{
    let stadium: String
    let createdAt: Date
    let homeScore: Int64
    let awayScore: Int64
}

struct CreatePlayersRequest: Codable{
    let name: String
    let position: String
    let team: String
    let nationality: String
    let photoURL: String
    let brithDate: Date
    let height: Double
    let weight: Double
    let rating: Double
    let stats: Double
}

struct CreateStadiumRequest: Codable{
    let city: String
    let country: String
    let name: String
    let team: String
    let imageURL: String
    let capacity: Int64
    
}

struct CreateTeamRequest: Codable{
    let coach: String
    let description: String
    let leagues: String
    let name: String
    let stadium: String
    let logoURL: String
    let foundedYear: Date
    let stats: Double
    
}
struct CreateLeagueRequest: Codable{
    let country: String
    let name: String
    
}
