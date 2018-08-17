//
//  FirstViewController.swift
//  Food
//
//  Created by Mike Drum on 7/22/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import UIKit

class EatViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MealCell.nib, forCellReuseIdentifier: MealCell.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: DayUpdateNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: DayUpdateNotification, object: nil)
    }

    @objc func update() {
        if !updating {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ObjectManager.shared.days.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ObjectManager.shared.days[section].meals().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.identifier) as! MealCell
        let meals = ObjectManager.shared.days[indexPath.section].meals()
        cell.meal = meals[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            beginUpdates()
            let day = ObjectManager.shared.days[indexPath.section]
            let meal = day.meals()[indexPath.item]
            switch meal.time {
            case .Breakfast: day.breakfast = nil
            case .Lunch: day.lunch = nil
            case .Dinner: day.dinner = nil
            }
            if day.isEmpty() {
                ObjectManager.shared.remove(day: day)
                tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .right)
            } else {
                tableView.deleteRows(at: [indexPath], with: .right)
            }
            endUpdates()
        }
    }
    
    private var updating: Bool = false
    private func beginUpdates() {
        updating = true
        self.tableView.beginUpdates()
    }
    private func endUpdates() {
        updating = false
        self.tableView.endUpdates()
    }

}

