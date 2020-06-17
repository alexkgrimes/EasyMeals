//
//  PlanHistoryViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 5/10/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit

class PlanHistoryViewController: UIViewController {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let tableViewHeaderHeight: CGFloat = 62.0
    }
    
    var dateString: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var day = DayPlan()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationController?.isNavigationBarHidden = false
        titleLabel.text = dateString
    }
}

extension PlanHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mealName = MealName(rawValue: mealNames[section]), let numRows = day.day[mealName]?.count else {
            return 0
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealItemCell", for: indexPath) as! MealItemCell
        guard let mealName = MealName(rawValue: mealNames[indexPath.section]), let foods = day.day[mealName] else {
            return cell
        }
        
        cell.foodLabel.text = foods[indexPath.row]
        cell.foodLabel.textColor = .black
        
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.layer.borderColor = UIColor.white.cgColor as CGColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "mealHeaderCell") as! MealHeaderCell
        
        header.mealNameLabel.text = mealNames[section]
        header.mealNameLabel.textColor = .white
        
        header.contentView.backgroundColor = .systemOrange
        header.contentView.layer.cornerRadius = Constants.cornerRadius
        header.contentView.layer.borderWidth = 0
        
        header.delegate = nil
        return header
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mealNames[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .white
        return footer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mealNames.count
    }
}
