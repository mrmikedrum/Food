//
//  ShopViewController.swift
//  Food
//
//  Created by Mike Drum on 7/22/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import UIKit

class ShopViewController: UITableViewController {
    
    private var deliIngredients: [Ingredient] = []
    private var produceIngredients: [Ingredient] = []
    private var meatIngredients: [Ingredient] = []
    private var dairyIngredients: [Ingredient] = []
    private var checkedIngredients: [Ingredient] = []
    
    private func generateShoppingList() {
        var ingredients: [Ingredient] = []
        for day in ObjectManager.shared.days {
            let meals = day.meals()
            meals.forEach { ingredients.append(contentsOf: $0.ingredients) }
        }
        
        ingredients.forEach { ingredient in
            let count = ingredients.filter { $0 == ingredient }.count
            let name = "\(count) \(ingredient.name)"
            let newElement = Ingredient(name: name, type: ingredient.type, area: ingredient.area)
            switch newElement.area {
            case .Dairy: if !self.dairyIngredients.contains(newElement) { self.dairyIngredients.append(newElement) }
            case .Deli: if !self.deliIngredients.contains(newElement) { self.deliIngredients.append(newElement) }
            case .Produce: if !self.produceIngredients.contains(newElement) { self.produceIngredients.append(newElement) }
            case .Meat: if !self.meatIngredients.contains(newElement) { self.meatIngredients.append(newElement) }
            }
        }
        
        self.checkedIngredients = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateShoppingList()
        // TODO: Save sates between loads
    }
    
    private enum Sections: Int {
        case Produce, Meat, Deli, Dairy, Checked, Count
    }
    
    private func ingredient(forIndexPath indexPath: IndexPath) -> Ingredient? {
        var ingredient: Ingredient?
        self.list(forSection: indexPath.section) { ingredient = $0[indexPath.item] }
        return ingredient
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.Count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        self.list(forSection: section) { count = $0.count }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient"), let ingredient = self.ingredient(forIndexPath: indexPath) else { return UITableViewCell() }
    
        cell.textLabel?.text = ingredient.name
        
        if indexPath.section == Sections.Checked.rawValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.Produce.rawValue: return "Produce"
        case Sections.Meat.rawValue: return "Meat"
        case Sections.Deli.rawValue: return "Deli"
        case Sections.Dairy.rawValue: return "Dairy"
        case Sections.Checked.rawValue: return "Done"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ingredient = self.ingredient(forIndexPath: indexPath), let cell = tableView.cellForRow(at: indexPath) else {return}
        
        tableView.beginUpdates()
        
        if indexPath.section == Sections.Checked.rawValue {
            // unchecking
            var newIndex = 0
            let newSection = self.section(forArea: ingredient.area)
            self.list(forSection: newSection) { $0.append(ingredient); newIndex = $0.count - 1 }
            self.checkedIngredients.remove(at: checkedIngredients.firstIndex(of: ingredient)!)
            tableView.moveRow(at: indexPath, to: IndexPath(item: newIndex, section: newSection))
            cell.accessoryType = .none
        } else {
            // checking
            self.checkedIngredients.append(ingredient)
            self.list(forSection: self.section(forArea: ingredient.area)) { $0.remove(at: $0.firstIndex(of: ingredient)!)}
            tableView.moveRow(at: indexPath, to: IndexPath(item: self.checkedIngredients.count - 1, section: Sections.Checked.rawValue))
            cell.accessoryType = .checkmark
        }
        
        tableView.endUpdates()
    }
    
    private func list(forSection section: Int, closure: (inout [Ingredient]) -> Void) {
        switch section {
        case Sections.Produce.rawValue: closure(&self.produceIngredients)
        case Sections.Meat.rawValue: closure(&self.meatIngredients)
        case Sections.Deli.rawValue: closure(&self.deliIngredients)
        case Sections.Dairy.rawValue: closure(&self.dairyIngredients)
        case Sections.Checked.rawValue: closure(&self.checkedIngredients)
        default: return
        }
    }
    
    private func section(forArea area: ShoppingArea) -> Int {
        switch area {
        case .Dairy: return Sections.Dairy.rawValue
        case .Deli: return Sections.Deli.rawValue
        case .Produce: return Sections.Produce.rawValue
        case .Meat: return Sections.Meat.rawValue
        }
    }
}


