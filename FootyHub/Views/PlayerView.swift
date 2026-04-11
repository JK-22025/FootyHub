//
//  PlayerView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-03.
//

import SwiftUI
import CoreData
struct PlayerView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var holder: FootyHolder
    @State private var playerName: String = ""
    @State private var searchDraft: String = ""
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PlayerView()
}
