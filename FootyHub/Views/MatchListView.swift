//
//  MatchListView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-29.
//

import SwiftUI
import CoreData
struct MatchListView: View {
    @EnvironmentObject var holder: FootyHolder
    @Environment(\.managedObjectContext) var context
    var body: some View {
        NavigationView{
            List{
                ForEach(holder.matches) { match in
                    NavigationLink {
                        Text("Match details")
                    } label: {
                        MatchRowItem(match: match)
                    }
                }
                .listRowSeparator(.visible)
                
            }
            .listStyle(.plain)
            .navigationTitle("Matches")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Today's Matches"){
                        holder.moveDate(days: 0, context)
                    }
                }
            }
        }
    }
    
    struct MatchRowItem: View {
        var match: Match
        var body: some View {
            HStack(alignment: .center) {
                VStack(alignment: .trailing) {
                    Text(match.homeTeam?.name ?? "Home Team")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text(match.awayTeam?.name ?? "Away Team")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    Text("\(match.homeScore)")
                    Text("-")
                    Text("\(match.awayScore)")
                }
                .font(.system(.body, design: .monospaced))
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.purple.opacity(0.1))
                .frame(width: 70)
            }
            .padding(8)
        }
    }
}

#Preview {
    MatchListView()
}
