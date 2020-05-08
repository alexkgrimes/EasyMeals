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

        DataController.setUpDates()
    }
    
    static func setUpDates() {
        // Configure the calendar if signed in, set up new dates and delete old ones
        if let userId = AuthController.userId, AuthController.isSignedIn {
            let calendar = Calendar.current
            let datesRef = Database.database().reference(withPath: "users").child("\(userId)/dates")
            datesRef.observeSingleEvent(of: .value, with: { snapshot in
                var storedDates: [String]  = []
                
                // delete old dates
                for dateChild in snapshot.children {
                    guard let dateSnapshot = dateChild as? DataSnapshot else { return }

                    let dateString  = dateSnapshot.key
                    let date = formatter.date(from: dateString)!
                    let currentDate = formatter.date(from: formatter.string(from: Date()))
                    if date < currentDate! {
                        let dateRef = datesRef.child(dateString)
                        dateRef.removeValue { error, _ in
                            print(error?.localizedDescription)
                        }
                    } else {
                        storedDates.append(dateString)
                    }
                }
                
                // create the new ones
                for index in 0...numberOfCalendarCells {
                    let dateForCell = calendar.date(byAdding: .day, value: index, to: Date())!
                    let dateString = formatter.string(from: dateForCell)
                    if !storedDates.contains(dateString) {
                        datesRef.child("\(dateString)").setValue(["Breakfast": "", "Lunch": "", "Dinner": "", "Snacks": "", "Fluids": ""])
                    }
                    
                }
            })
        }
    }
}
