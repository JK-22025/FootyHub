//
//  ProfileView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: FootyHolder
    
    @ObservedObject private var auth = AuthService.shared
    @State private var newName = ""
    @State private var errorMessage: String?
    var body: some View {
        Form{
            Section("Profile"){
                Text("Email: \(auth.currentUser?.email ?? "-")")
                Text("Display UserName: \(auth.currentUser?.displayName ?? "-")")
                Text("Is Active: \(auth.currentUser?.isActive == true ? "Yes": "False")")
            }
            
            Section("Update Display UserName"){
                TextField("New Display UserName", text: $newName)
                
                Button("Save"){
                    guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else{
                        self.errorMessage = "Display UserName cannot be empty"
                        return
                    }
                    
                    
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
