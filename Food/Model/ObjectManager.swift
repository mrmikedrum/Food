//
//  ObjectManager.swift
//  Food
//
//  Created by Mike Drum on 7/22/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import Foundation

let DayUpdateNotification = Notification.Name("DayUpdateNotification")
let MealUpdateNotification = Notification.Name("MealUpdateNotification")
let IngredientUpdateNotification = Notification.Name("IngredientUpdateNotification")

class ObjectManager {
    static let shared = ObjectManager()
    
    private var ready = false
    
    private(set) var days: [Day] = [] {
        didSet {
            sync()
        }
    }
    private(set) var meals: [Meal] = [] {
        didSet {
            sync()
        }
    }
    private(set) var ingredients: [Ingredient] = [] {
        didSet {
            sync()
        }
    }
    
    func bootstrap() {
        self.days = DataLoader.loadDays()
        self.meals = DataLoader.loadMeals()
        self.ingredients = DataLoader.loadIngredients()
        self.ready = true
    }
    
    func sync() {
        guard ready else {return}
        
        DataLoader.save(days: self.days)
        DataLoader.save(meals: self.meals)
        DataLoader.save(ingredients: self.ingredients)
        NotificationCenter.default.post(Notification(name: DayUpdateNotification))
        NotificationCenter.default.post(Notification(name: MealUpdateNotification))
        NotificationCenter.default.post(Notification(name: IngredientUpdateNotification))
    }
    
    func add(day: Day) {
        days.append(day)
    }
    
    func add(ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    func add(meal: Meal) {
        meals.append(meal)
    }
    
    func remove(day: Day) {
        days.remove(at: ObjectManager.shared.days.index(of: day)!)
    }
}
