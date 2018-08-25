//
//  AddMealViewController.swift
//  Food
//
//  Created by Mike Drum on 7/28/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import UIKit

class AddMealViewController: UITableViewController {
    
    private func loadIngredients() {
        self.proteins = ObjectManager.shared.ingredients.filter { $0.type == .Protein }.sorted()
        self.vegetables = ObjectManager.shared.ingredients.filter { $0.type == .Vegetable }.sorted()
        self.others = ObjectManager.shared.ingredients.filter { $0.type == .Other }.sorted()
    }
    
    private var proteins: [Ingredient] = []
    private var vegetables: [Ingredient] = []
    private var others: [Ingredient] = []
    
    private var selectedIngredients: [Ingredient] = []
    private var selectedTime: MealTime? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIngredients()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: IngredientUpdateNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: IngredientUpdateNotification, object: nil)
    }
    
    @objc private func update() {
        self.loadIngredients()
        self.tableView.reloadData()
    }
    
    private enum Sections: Int {
        case Proteins, Vegetables, Other, Time, Count
    }
    
    private enum TimeRows: Int {
        case Breakfast, Lunch, Dinner, Count
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddIngredient", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard !self.selectedIngredients.isEmpty, let time = self.selectedTime else { return }
        
        ObjectManager.shared.add(meal: Meal(ingredients: self.selectedIngredients, time: time ))
        self.navigationController?.popViewController(animated: true)
    }
    
    private func ingredient(atIndexPath indexPath: IndexPath) -> Ingredient? {
        switch indexPath.section {
        case Sections.Proteins.rawValue: return self.proteins[indexPath.item]
        case Sections.Vegetables.rawValue: return self.vegetables[indexPath.item]
        case Sections.Other.rawValue: return self.others[indexPath.item]
        default: return nil
        }
    }
    
    private func time(atIndexPath indexPath: IndexPath) -> MealTime? {
        guard indexPath.section == Sections.Time.rawValue else {return nil}
        
        switch indexPath.item {
        case TimeRows.Breakfast.rawValue: return .Breakfast
        case TimeRows.Lunch.rawValue: return .Lunch
        case TimeRows.Dinner.rawValue: return .Dinner
        default: return nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.Count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.Proteins.rawValue: return self.proteins.count
        case Sections.Vegetables.rawValue: return self.vegetables.count
        case Sections.Other.rawValue: return self.others.count
        case Sections.Time.rawValue: return 3
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        
        if let ingredient = self.ingredient(atIndexPath: indexPath) {
            cell.textLabel?.text = ingredient.name
            cell.accessoryType = self.selectedIngredients.contains(ingredient) ? .checkmark : .none
        }
        if let time = self.time(atIndexPath: indexPath) {
            cell.textLabel?.text = time.rawValue
            cell.accessoryType = self.selectedTime == time ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.Proteins.rawValue: return "Proteins"
        case Sections.Vegetables.rawValue: return "Vegetables"
        case Sections.Other.rawValue: return "Others"
        case Sections.Time.rawValue: return "Time"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}

        if let ingredient = self.ingredient(atIndexPath: indexPath) {
            if self.selectedIngredients.contains(ingredient) {
                self.selectedIngredients = self.selectedIngredients.filter {$0 != ingredient}
                cell.accessoryType = .none
            } else {
                self.selectedIngredients.append(ingredient)
                cell.accessoryType = .checkmark
            }
        }
        if let time = self.time(atIndexPath: indexPath) {
            self.selectedTime = self.selectedTime == time ? nil : time
            cell.accessoryType = self.selectedTime == time ? .checkmark : .none
        }
    }
}
