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
    @IBOutlet weak var tableView: UITableView!
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var mealTapped = ""
    
    // TODO: make real data
    let calendarDays = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    let calendarDates = ["Aug 10", "Aug 11", "Aug 12", "Aug 13", "Aug 14", "Aug 15", "Aug 16"]
    let planHeaders = ["Breakfast", "Lunch", "Dinner", "Snacks", "Fluids"]
    
    var meals: [String : [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        meals = ["Breakfast" : [], "Lunch" : [], "Dinner" : [], "Snacks" : [], "Fluids" : []]
        
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 4
        calendarFlowLayout.minimumInteritemSpacing = 4
        calendarFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddItemViewController {
            controller.delegate = self
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
    }
}

// MARK: - TableViewDelegate

extension YourPlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numRows = meals[planHeaders[section]]?.count else {
            return 0
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealItemCell", for: indexPath) as! MealItemCell
        let itemsInSection = meals[planHeaders[indexPath.section]]
        
        cell.foodLabel.text = itemsInSection?[indexPath.row]
        cell.foodLabel.textColor = .black
        
        cell.backgroundColor = .white
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layer.borderColor = UIColor.white.cgColor as CGColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "mealHeaderCell") as! MealHeaderCell
        let violet = hexStringToUIColor(hex: "6c71c4")

        header.mealNameLabel.text = planHeaders[section]
        header.mealNameLabel.textColor = .white
        header.addItemButton.setTitleColor(.white, for: .normal)
        
        header.contentView.backgroundColor = violet
        header.layer.cornerRadius = 16.0
        header.layer.borderWidth = 0
        
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return planHeaders.count
    }
}

// MARK: - CollectionView Delegate

extension YourPlanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        let cyan = hexStringToUIColor(hex: "2aa198")
        
        cell.dayLabel.text = calendarDays[indexPath.row]
        cell.dateLabel.text = calendarDates[indexPath.row]
        cell.dayLabel.textColor = .white
        cell.dateLabel.textColor = .white
        
        cell.backgroundColor = cyan
        cell.layer.cornerRadius = 16.0
        
        return cell
    }
}

// MARK: - AddFoodDelegate

extension YourPlanViewController: AddFoodDelegate {
    func doneButtonTapped(for newFood: String)
    {
            meals[mealTapped]?.append(newFood)
            tableView.reloadData()
    }
}

// MARK: - CreateMealDelegate

extension YourPlanViewController: CreateMealDelegate {
    func mealButtonPressed(for mealType: String) {
        mealTapped = mealType
    }
}


// MARK: - Colors

extension YourPlanViewController {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

