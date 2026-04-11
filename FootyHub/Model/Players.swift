//
//  Players.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-06.
//

import Foundation

struct PlayersDTO: Codable, Identifiable{
    let id: String
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
