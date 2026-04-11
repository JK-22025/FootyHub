//
//  Stadium.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-06.
//

import Foundation
struct StadiumDTO: Codable, Identifiable{
    let id: String
    let city: String
    let country: String
    let name: String
    let team: String
    let imageURL: String
    let capacity: Int64
    
}
