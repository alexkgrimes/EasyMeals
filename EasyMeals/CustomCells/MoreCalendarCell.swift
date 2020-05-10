//
//  MoreCalendarCell.swift
//  EasyMeals
//
//  Created by Alex Grimes on 5/9/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

protocol MoreCalendarCellProtocol {
    func pushMoreDatesView()
}

class MoreCalendarCell: UICollectionViewCell {
    
    var delegate: MoreCalendarCellProtocol? = nil
    
    @IBOutlet weak var moreLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func pushMore() {
        delegate?.pushMoreDatesView()
    }
}
