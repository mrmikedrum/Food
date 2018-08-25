//
//  SecondViewController.swift
//  Food
//
//  Created by Mike Drum on 7/22/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import UIKit

class PlanViewController: UITableViewController {
    
    var breakfasts: [Meal] = []
    var lunches: [Meal] = []
    var dinners: [Meal] = []
    
    var selectedBreakfast: Meal?
    var selectedLunch: Meal?
    var selectedDinner: Meal?

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private func loadMeals() {
        self.breakfasts = ObjectManager.shared.meals.filter {$0.time == .Breakfast}
        self.lunches = ObjectManager.shared.meals.filter {$0.time == .Lunch}
        self.dinners = ObjectManager.shared.meals.filter {$0.time == .Dinner}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MealCell.nib, forCellReuseIdentifier: MealCell.identifier)
        
        loadMeals()

        self.saveButton.isEnabled = validate()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: MealUpdateNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MealUpdateNotification, object: nil)
    }
    
    @objc private func update() {
        self.loadMeals()
        self.tableView.reloadData()
    }
    
    private func validate() -> Bool {
        return self.selectedBreakfast != nil ||
                self.selectedLunch != nil ||
                self.selectedDinner != nil
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard validate() else {return}
        
        let day = Day(breakfast: selectedBreakfast, lunch: selectedLunch, dinner: selectedDinner)
        ObjectManager.shared.add(day: day)
        
        self.selectedBreakfast = nil
        self.selectedLunch = nil
        self.selectedDinner = nil
        self.tableView.reloadData()
        self.saveButton.isEnabled = false
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddMeal", sender: self)
    }
    
    private func meal(forIndexPath indexPath: IndexPath) -> Meal? {
        switch indexPath.section {
        case 0:
            if let meal = self.selectedBreakfast {
                return meal
            } else {
                return self.breakfasts[indexPath.item]
            }
        case 1:
            if let meal = self.selectedLunch {
                return meal
            } else {
                return self.lunches[indexPath.item]
            }
        case 2:
            if let meal = self.selectedDinner {
                return meal
            } else {
                return self.dinners[indexPath.item]
            }
        default: return nil;
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.selectedBreakfast == nil ? self.breakfasts.count : 1
        case 1: return self.selectedLunch == nil ? self.lunches.count : 1
        case 2: return self.selectedDinner == nil ? self.dinners.count : 1
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.identifier) as! MealCell
        cell.includesTitle = false
        
        guard let meal = self.meal(forIndexPath: indexPath) else {return cell}
        cell.meal = meal
        
        switch meal.time {
        case .Breakfast: cell.accessoryType = meal == self.selectedBreakfast ? .checkmark : .none
        case .Lunch: cell.accessoryType = meal == self.selectedLunch ? .checkmark : .none
        case .Dinner: cell.accessoryType = meal == self.selectedDinner ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Breakfast"
        case 1: return "Lunch"
        case 2: return "Dinner"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MealCell, let meal = cell.meal else {return}
        
        let selecting = cell.accessoryType == .none
        cell.accessoryType = selecting ? .checkmark : .none

        tableView.beginUpdates()

        switch meal.time {
        case .Breakfast: self.selectedBreakfast = selecting ? meal : nil
        case .Lunch: self.selectedLunch = selecting ? meal : nil
        case .Dinner: self.selectedDinner = selecting ? meal : nil
        }
        
        var rows: [IndexPath] = []
        if selecting {
            for index in 0..<tableView.numberOfRows(inSection: indexPath.section) {
                if indexPath.item != index {
                    rows.append(IndexPath(item: index, section: indexPath.section))
                }
            }
            tableView.deleteRows(at: rows, with: .middle)
        } else {
            for index in 0..<self.tableView(tableView, numberOfRowsInSection: indexPath.section) {
                let insertedIndexPath = IndexPath(item: index, section: indexPath.section)
                if meal != self.meal(forIndexPath: insertedIndexPath) {
                    rows.append(insertedIndexPath)
                }
            }
            tableView.insertRows(at: rows, with: .middle)
        }
        tableView.endUpdates()
        
        self.saveButton.isEnabled = validate()
    }
}

