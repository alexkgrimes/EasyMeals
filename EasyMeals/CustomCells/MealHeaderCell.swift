//
//  MealHeaderCell.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/13/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

protocol CreateMealDelegate: class {
    func mealButtonPressed(for mealType: String)
}

class MealHeaderCell: UITableViewCell {
    var headerCellSection:Int?

    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var addItemButton: UIButton!
    
    weak var delegate: CreateMealDelegate?
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let mealName = mealNameLabel.text else {
            return
        }
        delegate?.mealButtonPressed(for: mealName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
