//
//  MealHeaderCell.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/13/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

class MealHeaderCell: UITableViewCell {

    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var addItemButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
