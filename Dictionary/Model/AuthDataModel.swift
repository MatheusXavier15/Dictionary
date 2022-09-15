//
//  AuthViewModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 14/09/22.
//

import Foundation
import Firebase

class AuthDataModel {
    static let shared = AuthDataModel()
    var userSession: FirebaseAuth.User?
    var currentUser: User?
    
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String, completion: @escaping()->Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
            completion()
        }
    }
    
    func register(withEmail email: String, password: String, username: String, fullname: String){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Successfully registered user...")
            guard let user = result?.user else { return }
            self.userSession = user
            let data = ["email": email, "username": username, "fullname": fullname, "uid": user.uid]
            
            COLLECTION_USERS.document(user.uid).setData(data) { _ in
                self.userSession = user
                print("Successfully uploaded user data...")
            }
        }
    }
    
    func fetchUser(){
        guard let userSession = userSession else {
            return
        }
        COLLECTION_USERS.document(userSession.uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let user = try? snapshot?.data(as: User.self) else { return }
            self.currentUser = user
        }
    }
}
