//
//  SignupView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-24.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: FootyHolder
    
    @State private var email = ""
    @State private var password = ""
    @State private var displayUserName = ""
    @State private var errorMessage: String?
    @StateObject private var auth = AuthService.shared
    var body: some View {
        Form{
            Section("Create Account"){
                TextField("Enter Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                
                SecureField("Password(Min 6 chars)", text: $password)
                TextField("Enter Username", text: $displayUserName)
            }
            
            if let errorMessage = errorMessage{
                Text(errorMessage).foregroundStyle(.red)
            }
            
            Button("Sign Up"){
                print("Sign up clicked")
                
                
            }
        }
    }
}

#Preview {
    SignupView()
}
