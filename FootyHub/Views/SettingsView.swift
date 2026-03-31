//
//  SettingsView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-25.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: FootyHolder
    
    @State private var profile: String = ""
    @State private var profileImage: String?
    @State private var errorMessage: String?
    var body: some View {
        NavigationStack{
            List{
                //NavigationLink("Profile"){ProfileView()}
            }.navigationTitle("Settings")
        }
        
        }
    
    
    
    
    
    
    
    
    
    
    
    
    }

#Preview {
    SettingsView()
}
