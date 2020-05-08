//
//  FullPlan.swift
//  EasyMeals
//
//  Created by Alex Grimes on 5/7/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import Foundation
import Firebase


public let calendarDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
public let calendarMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
public let mealNames = ["Breakfast", "Lunch", "Dinner", "Snacks", "Fluids"]

enum MealName: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snacks = "Snacks"
    case fluids = "Fluids"
}

let formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
}()


struct FullPlan {
    var plan: [Date : DayPlan] = [:] // [date: DayPlan]
    
    public init() {}
    
    public init(snapshot: DataSnapshot) {
        for dateChild in snapshot.children {
            guard let dateSnapshot = dateChild as? DataSnapshot, let date = formatter.date(from: dateSnapshot.key) else { return }

            plan[date] = DayPlan()
            
            MealName.allCases.forEach {
                plan[date]?.day[$0] = []
            }
            
            for mealChild in dateSnapshot.children {
                guard let mealSnapshot = mealChild as? DataSnapshot else { return }

                let meal = mealSnapshot.key
                var newMeal : [String] = []
                
                for itemChild in mealSnapshot.children {
                    guard let itemSnapshot = itemChild as? DataSnapshot else { return }
                    
                    let item = itemSnapshot.key
                    newMeal.append(item)
                }
                 
                if let mealName = MealName(rawValue: meal) {
                    plan[date]?.day[mealName] = newMeal
                }
            }
        }
    }
}

struct DayPlan {
    var day: [MealName : [String]] = [:] // [mealName: listof foods]
}

