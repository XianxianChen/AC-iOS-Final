//
//  FirebaseAPIClient.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseAPIClient {
    static let manager = FirebaseAPIClient()
    private init() {}
    
    func loginUser(email: String, password: String, completionHandler: @escaping  (User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            if let user = user {
                completionHandler(user, nil)
            }
        }
    }
    func signOut() {
        do {
       try Auth.auth().signOut()
        } catch {
            print("Signing out error: \(error)")
        }
    }
    func creatNewAccout(email: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                //  print("create new account error: \(error)")
                completionHandler(nil, error)
            }
            if let user = user {
                let userProfileRef = Database.database().reference().child("users")
                let userProfile = UserProfile(email: email, userID: user.uid)
                userProfileRef.childByAutoId().setValue(userProfile.toJson())
                completionHandler(user, nil)
            }
        }
    }
}
