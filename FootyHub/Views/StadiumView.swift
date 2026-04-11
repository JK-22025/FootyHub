//
//  StadiumView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-04-02.
//

import SwiftUI
import CoreData
struct StadiumView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var holder: FootyHolder
    @State private var stadiumName: String = ""
    @State private var searchDraft: String = ""
    
    private let colms = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(),spacing: 12),
    ]
    
    var body: some View {
        let imageURL = ""
        NavigationView{
            VStack(spacing: 10){
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search Stadium...", text: $searchDraft)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding(12)
                .background(.secondary.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
                .onChange(of: searchDraft) { _, newValue in
                    holder.setSearch(newValue, context)
                }
                
                ScrollView {
                    LazyVGrid(columns: colms, spacing: 12) {
                        // Use your data source and limit to five items
                        ForEach(holder.stadiums.prefix(5), id: \.objectID) { stadium in
                            Stadiumcards(stadium: stadium)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    struct Stadiumcards: View {
        let stadium: Stadium
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.secondary.opacity(0.12))
                        .frame(height: 110)
                    Image(systemName: stadium.imageURL ?? "")
                        .font(.system(size: 34, weight: .semibold))
                    
                }
                Text(stadium.name ?? "Anfield")
                    .font(.headline)
                    .lineLimit(1)
                Text(stadium.city ?? "LiverPool")
                    .font(.headline)
                    .lineLimit(1)
                Text(stadium.country ?? "England")
                    .font(.headline)
                    .lineLimit(1)
                Text(stadium.team ?? "Liverpool FC")
                    .font(.headline)
                    .lineLimit(1)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.secondary.opacity(0.12))
                        .frame(height: 110)
                    Image(systemName: stadium.imageURL ?? "")
                        .font(.system(size: 34, weight: .semibold))
                    
                }
                
            }
            Text(stadium.name ?? "Camp Nou")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.city ?? "Barcelona")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.country ?? "Spain")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.team ?? "Fc Barccelona")
                .font(.headline)
                .lineLimit(1)
            
            
            
            
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(.secondary.opacity(0.12))
                    .frame(height: 110)
                Image(systemName: stadium.imageURL ?? "")
                    .font(.system(size: 34, weight: .semibold))
                
                
            }
            Text(stadium.name ?? "San Siro")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.city ?? "Milan")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.country ?? "Italy")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.team ?? "AC Milan / Inter Milan")
                .font(.headline)
                .lineLimit(1)
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(.secondary.opacity(0.12))
                    .frame(height: 110)
                Image(systemName: stadium.imageURL ?? "")
                    .font(.system(size: 34, weight: .semibold))
                
                
            }

            Text(stadium.name ?? "Emirates Stadium")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.city ?? "London")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.country ?? "England")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.country ?? "Arsenal FC")
                .font(.headline)
                .lineLimit(1)
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(.secondary.opacity(0.12))
                    .frame(height: 110)
                Image(systemName: stadium.imageURL ?? "")
                    .font(.system(size: 34, weight: .semibold))
                
                
            }

            Text(stadium.name ?? "Saputo Stadium")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.city ?? "Montreal")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.country ?? "Canada")
                .font(.headline)
                .lineLimit(1)
            Text(stadium.team ?? "CF Montréal")
                .font(.headline)
                .lineLimit(1)
            
            
            
        }
    }
}


#Preview {
    StadiumView()
}

