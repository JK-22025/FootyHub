//
//  Team.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-06.
//

import Foundation

struct TeamDTO: Codable, Identifiable{
    let id: String
    let coach: String
    let description: String
    let leagues: String
    let name: String
    let stadium: String
    let logoURL: String
    let foundedYear: Date
    let stats: Double
    
}
