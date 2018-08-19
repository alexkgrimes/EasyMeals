//
//  ViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/12/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

class MyTapGesture: UITapGestureRecognizer {
    var title: String = ""
}

class YourPlanViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var mealPlanTableView: UITableView!
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddItemViewController {
            // set data for modal placeholder
            
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
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
        cell.backgroundColor = .white
        cell.foodLabel.textColor = .black
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layer.borderColor = UIColor.white.cgColor as CGColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let violet = hexStringToUIColor(hex: "6c71c4")

        let header = tableView.dequeueReusableCell(withIdentifier: "mealHeaderCell") as! MealHeaderCell
        
        header.mealNameLabel.text = planHeaders[section]
        header.mealNameLabel.textColor = .white
        header.addItemButton.setTitleColor(.white, for: .normal)
        header.contentView.backgroundColor = violet
        header.layer.cornerRadius = 16.0
        header.layer.borderWidth = 0
        
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
        let cyan = hexStringToUIColor(hex: "2aa198")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.backgroundColor = cyan
        cell.dayLabel.text = calendarDays[indexPath.row]
        cell.dateLabel.text = calendarDates[indexPath.row]
        cell.dayLabel.textColor = .white
        cell.dateLabel.textColor = .white
        cell.layer.cornerRadius = 16.0
        
        return cell
    }
}



//
// Colors
//
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

