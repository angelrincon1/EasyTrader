//
//  UserStateViewModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 11/20/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showAlert: Bool = false
    @Published var alertText: String = ""
    
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
        
    }
    
    func logIn(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.alertText = e.localizedDescription
                self.showAlert.toggle()
                return
            }
            
            guard let user = authResult?.user else {return}
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.alertText = e.localizedDescription
                self.showAlert.toggle()
                return
            }
            
            guard let user = authResult?.user else {return}
            self.userSession = user
        
            let data = ["email": email,
                        "username": username.lowercased(),
                        "fullname": fullname,
                        "cash": 10000,
                        "UID": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    self.fetchUser()
                }
        }
    }
    
    func logOut() {
        
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
}
