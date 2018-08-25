//
//  MealCell.swift
//  Food
//
//  Created by Mike Drum on 7/22/18.
//  Copyright © 2018 Drum Zone. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {
    
    static let nib = UINib(nibName: "MealCell", bundle: Bundle.main)
    static let identifier = "Meal"
    
    @IBOutlet weak var seperatorConstraint: NSLayoutConstraint?
    @IBOutlet weak var mealTypeLabel: UILabel!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    
    var meal: Meal? {
        didSet {
            updateUI()
        }
    }
    var includesTitle: Bool = true {
        didSet {
            self.mealTypeLabel.isHidden = !includesTitle
            seperatorConstraint?.isActive = includesTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateUI() {
        guard let meal = self.meal else {return}
        
        switch meal.time {
        case .Breakfast:
            mealTypeLabel.text = "Breakfast"
        case .Lunch:
            mealTypeLabel.text = "Lunch"
        case .Dinner:
            mealTypeLabel.text = "Dinner"
        }
        
        let labels = self.labels(withCount: meal.ingredients.count)
        var index = 0
        for ingredient in meal.ingredients {
            labels[index].isHidden = false
            labels[index].text = ingredient.name
            index += 1
        }
    }
    
    private func labels(withCount count: Int) -> [UILabel] {
        if var labels = self.ingredientsStackView.subviews as? [UILabel], labels.count > 0 {
            while labels.count < count {
                let newLabel = labels[0].createCopy()
                self.ingredientsStackView.addArrangedSubview(newLabel)
                labels.append(newLabel)
            }
            return labels
        }
        return []
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let labels = self.ingredientsStackView.subviews as? [UILabel] else {return}
        
        for label in labels {
            label.isHidden = true
        }
    }
}

extension UILabel {
    func createCopy() -> UILabel {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as! UILabel
    }
}
