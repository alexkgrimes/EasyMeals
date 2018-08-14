//
//  CalendarCell.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/13/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
