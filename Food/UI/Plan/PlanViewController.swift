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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.breakfasts.count
        case 1: return self.lunches.count
        case 2: return self.dinners.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.identifier) as! MealCell
        switch indexPath.section {
        case 0:
            cell.meal = self.breakfasts[indexPath.item]
            cell.accessoryType = self.selectedBreakfast == cell.meal ? .checkmark : .none
        case 1:
            cell.meal = self.lunches[indexPath.item]
            cell.accessoryType = self.selectedLunch == cell.meal ? .checkmark : .none

        case 2:
            cell.meal = self.dinners[indexPath.item]
            cell.accessoryType = self.selectedDinner == cell.meal ? .checkmark : .none

        default: break;
        }
        cell.includesTitle = false
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
        
        let selecting: Bool
        switch cell.accessoryType {
        case .checkmark:
            cell.accessoryType = .none
            selecting = false
            
        default:
            cell.accessoryType = .checkmark
            selecting = true
        }

        switch meal.time {
        case .Breakfast: self.selectedBreakfast = selecting ? meal : nil
        case .Lunch: self.selectedLunch = selecting ? meal : nil
        case .Dinner: self.selectedDinner = selecting ? meal : nil
        }
        
        self.saveButton.isEnabled = validate()
        print(validate())
    }
}

