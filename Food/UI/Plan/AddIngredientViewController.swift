//
//  AddIngredientViewController.swift
//  Food
//
//  Created by Mike Drum on 7/28/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import UIKit

class AddIngredientViewController: UITableViewController {
    
    private var name: String = ""
    private var type: FoodType?
    private var area: ShoppingArea?
    
    private let typeIndexPath = IndexPath(item: 0, section: 1)
    private let areaIndexPath = IndexPath(item: 0, section: 2)
    
    
    @IBAction func nameUpdated(_ sender: UITextField) {
        self.name = sender.text ?? ""
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let type = self.type, let area = self.area, !name.isEmpty else { return }
        let ingredient = Ingredient(name: self.name, type: type, area: area)
        ObjectManager.shared.add(ingredient: ingredient)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        switch indexPath {
        case typeIndexPath:
            alert.addAction(UIAlertAction(title: "Protein", style: .default) { [unowned self] (action) in
                self.type = .Protein
            })
            alert.addAction(UIAlertAction(title: "Vegetable", style: .default) { [unowned self] (action) in
                self.type = .Vegetable
            })
            alert.addAction(UIAlertAction(title: "Other", style: .default) { [unowned self] (action) in
                self.type = .Other
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        case areaIndexPath:
            alert.addAction(UIAlertAction(title: "Produce", style: .default) { [unowned self] (action) in
                self.area = .Produce
            })
            alert.addAction(UIAlertAction(title: "Meat", style: .default) { [unowned self] (action) in
                self.area = .Meat
            })
            alert.addAction(UIAlertAction(title: "Deli", style: .default) { [unowned self] (action) in
                self.area = .Deli
            })
            alert.addAction(UIAlertAction(title: "Dairy", style: .default) { [unowned self] (action) in
                self.area = .Dairy
            })
            alert.addAction(UIAlertAction(title: "Frozen", style: .default) { [unowned self] (action) in
                self.area = .Frozen
            })
            alert.addAction(UIAlertAction(title: "Miscellaneous", style: .default) { [unowned self] (action) in
                self.area = .Misc
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        default: return
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
