//
//  LoginView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-04.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: FootyHolder
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @StateObject private var auth = AuthService.shared
    var body: some View {
        Form{
            Section("Login"){
                TextField("Enter Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                
                SecureField("Password(Min 6 chars)", text: $password)
            }
            
            if let errorMessage = errorMessage{
                Text(errorMessage).foregroundStyle(.red)
            }
            
            Button("Login"){
                print("Login clicked")
                
                guard Validators.isEmailValid(email) else{
                    self.errorMessage = "Invalid Email"
                    return
                }
                
                guard Validators.isValidPassword(password)
                else{
                    self.errorMessage = "Invalid Password"
                    return
                }
                
                
                auth.login(email: email, password: password) { result in
                    switch result {
                    case .success:
                        self.errorMessage = nil
                    case .failure(let failure):
                        self.errorMessage = failure.localizedDescription
                    }
                }
            }
            
            .disabled(email.isEmpty || password.isEmpty)
        }
        
        
    }
}

#Preview {
    LoginView()
}
