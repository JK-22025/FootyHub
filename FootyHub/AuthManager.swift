//
//  AuthManager.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-08.
//

import Foundation
import Combine
import FirebaseAuth

class AuthManager: ObservableObject{
    @Published var user: User?
    
    init(){
        self.user = Auth.auth().currentUser
    }
    
    // register
    func register(email: String, password: String, completion: @escaping
    (Result<User, Error>)-> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error{
                completion(.failure(error))
            }else if let user = result?.user{
                self.user = user
                completion(.success(user))
            }
        }
    }
    
    func login(email: String, Password: String, completion: @escaping (Result <User, Error> )-> Void){
        Auth.auth().signIn(withEmail: email, password: Password) { result, error in
            if let error = error{
                completion(.failure(error))
            }else if let user = result?.user{
                self.user = user
                completion(.success(user))
            }
        }
    }
    
    func logout(){
        do{
          try Auth.auth().signOut()
            self.user = nil
        }catch{
            print("Error Signing out: \(error.localizedDescription)")
        }
    }
    
    
}
