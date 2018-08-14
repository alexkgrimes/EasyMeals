//
//  ViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/12/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

class YourPlanViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var mealPlanTableView: UITableView!
    
    let calendarDays = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    let calendarDates = ["Aug 10", "Aug 11", "Aug 12", "Aug 13", "Aug 14", "Aug 15", "Aug 16"]
    
    let planHeaders = ["Breakfast", "Lunch", "Dinner", "Snacks", "Fluids"]
    
    let breakfastFoods = ["Eggs (2)", "Oatmeal"]
    let lunchFoods = ["Turkey Sandwich", "Apple", "Chips"]
    let dinnerFoods = ["Trader Joe's Pasta", "Asparagus"]
    let snackFoods = ["Trail mix"]
    let fluids = ["1 GGB"]
    
    let meals: [String : [String]] = ["Breakfast" : ["Eggs (2)", "Oatmeal"], "Lunch" : ["Turkey Sandwich", "Apple", "Chips"], "Dinner" : ["Trader Joe's Pasta", "Asparagus"], "Snacks" : ["Trail mix"], "Fluids" : ["1 GGB"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 4
        calendarFlowLayout.minimumInteritemSpacing = 4
        calendarFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YourPlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numRows = meals[planHeaders[section]]?.count else {
            return 0
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealItemCell", for: indexPath) as! MealItemCell
        cell.backgroundColor = .gray
        let itemsInSection = meals[planHeaders[indexPath.section]]
        
        cell.foodLabel.text = itemsInSection?[indexPath.row]
        cell.backgroundColor = .purple
        cell.foodLabel.textColor = .white
        cell.layer.cornerRadius = 16.0
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.white.cgColor as CGColor
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        // return planHeaders[section]
        
        let header = tableView.dequeueReusableCell(withIdentifier: "mealHeaderCell") as! MealHeaderCell
        header.mealNameLabel.text = planHeaders[section]
        header.mealNameLabel.textColor = .black
        header.contentView.backgroundColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return planHeaders.count
    }
}

extension YourPlanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.backgroundColor = .blue
        cell.dayLabel.text = calendarDays[indexPath.row]
        cell.dateLabel.text = calendarDates[indexPath.row]
        cell.dayLabel.textColor = .white
        cell.dateLabel.textColor = .white
        cell.layer.cornerRadius = 16.0
        
        return cell
    }
}

