//
//  DataController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 5/3/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import Firebase

final class DataController {
    static let rootRef = Database.database().reference()
    
    static let usersRef = Database.database().reference(withPath: "users")
    
    static func addUser(with uid: String, email: String) {
        let emailRef = usersRef.child("\(uid)/email")
        emailRef.setValue(email)
    }
}
