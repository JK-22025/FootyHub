//
//  AuthService.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-02-23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject{
    static let shared = AuthService()
    @Published var currentUser: AppUser?
    private let db = Firestore.firestore()
    //MARK: Signup
    func signUp(email: String, password: String, displayUserName: String, completion: @escaping (Result<AppUser, Error>)-> Void){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            //MARK: guard statment
            guard let user = result?.user else{
                return completion(.failure(SimpleError("Unable to create")))
            }
            
            let uid = user.uid
            let appUser = AppUser(id: uid, email: email, displayName: displayUserName)
            
            
            do{
                try self.db.collection("users").document(uid).setData(from: appUser){
                    error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                    DispatchQueue.main.async {
                        self.currentUser = appUser
                    }
                    completion(.success(appUser))
                }
            }catch{
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    //MARK: LOGIN
    func login(email: String, password: String, completion: @escaping(Result<AppUser, Error>) -> Void){
        
        // check email , password, trim both email and password before sign in (email ---> lowercase)
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print(error.localizedDescription)
                completion(.failure(error))
            }else if let user = result?.user{
                let uid = user.uid
                
                self.fetchCurrentAppUser { res in
                    switch res {
                    case .success(let appUserObj):
                        if let appUser = appUserObj{
                            completion(.success(appUser))
                        }else{
                            completion(.failure(SimpleError("Unable to fetch User Details")))
                        }
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                }
            }
        }
    }
    
    
    //MARK: fetchcurrentappuser
    func fetchCurrentAppUser(completion: @escaping (Result<AppUser?, Error>)-> Void){
        guard let uid = Auth.auth().currentUser?.uid else{
            DispatchQueue.main.async {
                self.currentUser = nil
            }
            return completion(.success(nil))
        }
        
        db.collection("users").document(uid).getDocument{ snap, error in
            if let error = error{
                return completion(.success(nil))
            }
            do{
                let user = try snap?.data(as: AppUser.self)
                DispatchQueue.main.async {
                    self.currentUser = user
                }
                completion(.success(user))
            }catch{
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    //MARK: UpdateProfile
    func updateProfile(displayName: String, completion: @escaping (Result<Void, Error>)-> Void){
        // uid
        guard let uid = Auth.auth().currentUser?.uid else{
            return completion(.failure(SimpleError("Unable to fetch User details")))
        }
        
        db.collection("users").document(uid).updateData(["displayName":displayName]) { error in
            if let error = error{
                return completion(.failure(error))
            }else{
                
                self.fetchCurrentAppUser { _ in
                    completion(.success(()))
                }
            }
        }
    }
    
    //MARK: Signout
    func signOut() -> Result<Void, Error>{
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
            }
            return .success(())
        }catch{
            print(error.localizedDescription)
            return .failure(error)
        }
        
        
        
    }
    //MARK: SimpleError
    
    struct SimpleError: Error{
        let message: String
        init(_ message: String) {
            self.message = message
        }
        var localizedDescription: String{
            return message
        }
    }
}
