//
//  MatchModel.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-09.
//

import Foundation

struct MatchModel: Identifiable{
    let id = UUID()
    let stadium: String
    let homeTeam: Int16
    let awayTeam: Int16
}
enum Matches: String{
    case Hometeam, Awayteam, Stadium
}
