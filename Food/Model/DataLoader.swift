//
//  DataLoader.swift
//  Food
//
//  Created by Mike Drum on 7/22/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import Foundation

fileprivate let DaysKey = "Days"
fileprivate let MealsKey = "Meals"
fileprivate let IngredientsKey = "Ingredients"

class DataLoader {
    static func loadDays() -> [Day] {
        if let userData = UserDefaults.standard.data(forKey: DaysKey),
            let days = try? JSONDecoder().decode([Day].self, from: userData) {
            return days
        }
        let meals = loadMeals()
        let days = [Day(breakfast: meals[0], lunch: meals[1], dinner: meals[2])]
        return days
    }
    
    static func loadIngredients() -> [Ingredient] {
        if let userData = UserDefaults.standard.data(forKey: IngredientsKey),
            let ingredients = try? JSONDecoder().decode([Ingredient].self, from: userData) {
            return ingredients
        }
        
        let eggs = Ingredient(name: "Eggs", type: .Protein, area: .Dairy)
        let spinach = Ingredient(name: "Spinach", type: .Vegetable, area: .Produce)
        let chicken = Ingredient(name: "Chicken", type: .Protein, area: .Meat)
        let lettuce = Ingredient(name: "Lettuce", type: .Vegetable, area: .Produce)
        let salmon = Ingredient(name: "Salmon", type: .Protein, area: .Meat)
        let broccoli = Ingredient(name: "Broccoli", type: .Vegetable, area: .Produce)
        return [eggs, spinach, chicken, lettuce, salmon, broccoli]
    }
    
    static func loadMeals() -> [Meal] {
        if let userData = UserDefaults.standard.data(forKey: MealsKey),
            let meals = try? JSONDecoder().decode([Meal].self, from: userData) {
            return meals
        }
        
        let ing = loadIngredients()
        let breakfast = Meal(ingredients: [ing[0], ing[1]], time: .Breakfast)
        let lunch = Meal(ingredients: [ing[2], ing[3]], time: .Lunch)
        let dinner = Meal(ingredients: [ing[4], ing[5]], time: .Dinner)
        return [breakfast, lunch, dinner]
    }
    
    static func save(days: [Day]) {
        if let encoded = try? JSONEncoder().encode(days) {
            UserDefaults.standard.set(encoded, forKey: DaysKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func save(meals: [Meal]) {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: MealsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func save(ingredients: [Ingredient]) {
        if let encoded = try? JSONEncoder().encode(ingredients) {
            UserDefaults.standard.set(encoded, forKey: IngredientsKey)
            UserDefaults.standard.synchronize()
        }
    }
}
