//
//  Food.swift
//  Food
//
//  Created by Mike Drum on 7/22/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import Foundation

enum FoodType: Int, Codable {
    case Protein, Vegetable, Other
}
enum ShoppingArea: Int, Codable {
    case Produce, Meat, Deli, Dairy, Frozen, Misc
}

struct Ingredient: Equatable, Codable, Comparable {
    static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name < rhs.name
    }
    
    let name: String
    let type: FoodType
    let area: ShoppingArea
}

enum MealTime: String, Codable {
    case Breakfast = "Breakfast", Lunch = "Lunch", Dinner = "Dinner"
}

struct Meal: Equatable, Codable {
    let ingredients: [Ingredient]
    let time: MealTime
}

class Day: Equatable, Codable {
    static func == (lhs: Day, rhs: Day) -> Bool {
        return  lhs.breakfast == rhs.breakfast &&
                lhs.lunch == rhs.lunch &&
                lhs.dinner == rhs.dinner
    }
    
    var breakfast: Meal? {
        didSet {
            if loaded { ObjectManager.shared.sync() }
        }
    }
    var lunch: Meal? {
        didSet {
            if loaded { ObjectManager.shared.sync() }
        }
    }
    var dinner: Meal? {
        didSet {
            if loaded { ObjectManager.shared.sync() }
        }
    }
    
    private var loaded = false
    
    init(breakfast: Meal?, lunch: Meal?, dinner: Meal?) {
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        loaded = true
    }
    
    func isEmpty() -> Bool {
        return breakfast == nil && lunch == nil && dinner == nil
    }
    
    func meals() -> [Meal] {
        var meals: [Meal] = []
        if let breakfast = self.breakfast { meals.append(breakfast) }
        if let lunch = self.lunch { meals.append(lunch) }
        if let dinner = self.dinner { meals.append(dinner) }
        return meals
    }
}
