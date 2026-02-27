//
//  AppUser.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-23.
//

import Foundation
import FirebaseFirestore
struct AppUser: Identifiable, Codable{
    @DocumentID var id: String?
    let email: String
    var displayName: String
    var isActive: Bool = true
}
