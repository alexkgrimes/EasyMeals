//
//  AuthController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 5/3/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

protocol AuthControllerOutput {
    func signInFailed()
    func signInSuccess()
    func createUserFailed()
}

protocol AuthControllerLogout {
    func signOut()
}

final class AuthController {
    static let serviceName = "InventoryManagerService"
    
    static var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static func signIn(output: AuthControllerOutput, _ email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authUser, signInError in
            if signInError != nil, authUser == nil {
                output.signInFailed()
            } else {
                output.signInSuccess()
            }
        }
    }
    
    static func signUp(output: AuthControllerOutput, _ email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authUser, createError in
            guard let uid = authUser?.user.uid, createError == nil else {
                output.createUserFailed()
                return
            }
            
            DataController.addUser(with: uid, email: email)
            
            Auth.auth().signIn(withEmail: email, password: password) { user, signInError in
                if signInError != nil, user == nil {
                    output.signInFailed()
                } else {
                    output.signInSuccess()
                }
            }
        }
    }
    
    static func signOut(output: AuthControllerLogout) {
        guard let _ = Auth.auth().currentUser else {
            return
        }
        
        do {
            try Auth.auth().signOut()
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        
        output.signOut()
    }
}
