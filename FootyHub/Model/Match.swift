//
//  Match.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-06.
//

import Foundation

struct MatchDTO: Codable, Identifiable{
    let id: String
    let stadium: String
    let createdAt: Date?
    let homeScore: Int64
    let awayScore: Int64
}
