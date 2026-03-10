//
//  PlayerModel.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-09.
//

import Foundation

struct PlayerModel: Identifiable{
    let id = UUID()
    let name: String
    let nationality: String
    let position: String
    let birthDate: Date
    let height: Double
    let weight: Double
    let rating: Double
    let photoURL: String
    let stats: Double
    let team: String
}

enum Player: String{
    case 
}
