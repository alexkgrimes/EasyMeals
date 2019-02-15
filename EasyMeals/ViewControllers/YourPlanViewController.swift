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
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let numberOfCalendarCells = 12
        static let tableViewHeaderHeight: CGFloat = 62.0
    }
    
    var numDaysInWeek: Int {
        return calendarDays.count
    }
    
    var numMonthsInYear: Int {
        return calendarMonths.count
    }
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var mealTapped: String? = nil
    var dateSelected: String? = nil
    
    let calendarDays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]
    let calendarMonths = ["Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sep", "Oct", "Nov"]
    let planHeaders = ["Breakfast", "Lunch", "Dinner", "Snacks", "Fluids"]
    
    var daysInCalendarCells: [String] = []
    var datesInCalendarCells: [String] = []
    
    // var meals: [String : [String]] = [:]
    struct FullPlan {
        var plan: [String : DayPlan] = [:]
    }
    
    struct DayPlan {
        var day: [String : [String]] = [:]
    }
    
    var fullPlan = FullPlan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up calendar
        let calendar = Calendar.current
        for indexPathForCell in 0...Constants.numberOfCalendarCells {
            let dateForCell = calendar.date(byAdding: .day, value: indexPathForCell, to: Date())!
            let dayOfTheWeek = calendar.component(.weekday, from: dateForCell)
            let date = calendar.component(.day, from: dateForCell)
            let month = calendar.component(.month, from: dateForCell)
            
            daysInCalendarCells.append(calendarDays[dayOfTheWeek % numDaysInWeek])
            datesInCalendarCells.append(calendarMonths[month % numMonthsInYear] + " \(date)")
        }
        
        // Set up data for tableview
//        planHeaders.forEach { header in
//            meals[header] = []
//        }
        
        dateSelected = datesInCalendarCells[0]
        for date in datesInCalendarCells {
            fullPlan.plan[date] = DayPlan()
            for header in planHeaders {
                fullPlan.plan[date]?.day[header] = []
            }
        }
            
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
        guard let date = dateSelected, let plan = fullPlan.plan[date], let numRows = plan.day[planHeaders[section]]?.count else {
            return 0
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealItemCell", for: indexPath) as! MealItemCell
        guard let date = dateSelected, let dayPlan = fullPlan.plan[date], let foods = dayPlan.day[planHeaders[indexPath.section]] else {
            return cell
        }
        
        cell.foodLabel.text = foods[indexPath.row]
        cell.foodLabel.textColor = .black
        
        cell.backgroundColor = .white
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layer.borderColor = UIColor.white.cgColor as CGColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let date = dateSelected, let dayPlan = fullPlan.plan[date], var _ = dayPlan.day[planHeaders[indexPath.section]] else {
            return
        }
        
        if editingStyle == .delete {
            fullPlan.plan[date]?.day[planHeaders[indexPath.section]]!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        let header = tableView.dequeueReusableCell(withIdentifier: "mealHeaderCell") as! MealHeaderCell
        let violet = hexStringToUIColor(hex: "6c71c4")

        header.mealNameLabel.text = planHeaders[section]
        header.mealNameLabel.textColor = .white
        header.addItemButton.setTitleColor(.white, for: .normal)
        
        header.contentView.backgroundColor = violet
        header.contentView.layer.cornerRadius = Constants.cornerRadius
        header.contentView.layer.borderWidth = 0
        
        header.delegate = self
        
        containerView.addSubview(header)
        return containerView
        
        //return header
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return planHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.tableViewHeaderHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(planHeaders.count)
        return planHeaders.count
    }
}

// MARK: - CollectionView Delegate

extension YourPlanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfCalendarCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        let cyan = hexStringToUIColor(hex: "2aa198")
        
        cell.dayLabel.text = daysInCalendarCells[indexPath.row]
        cell.dateLabel.text = datesInCalendarCells[indexPath.row]
        cell.dayLabel.textColor = .white
        cell.dateLabel.textColor = .white
        
        cell.backgroundColor = cyan
        cell.layer.cornerRadius = Constants.cornerRadius
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        dateSelected = datesInCalendarCells[indexPath.row]
        tableView.reloadData()
        
        //Briefly fade the cell on selection
        UIView.animate(withDuration: 0.3, animations: {
            cell?.alpha = 0.5
        }) { (completed) in
            UIView.animate(withDuration: 0.3, animations: {
                cell?.alpha = 1
            })
        }
    }
}

// MARK: - AddFoodDelegate

extension YourPlanViewController: AddFoodDelegate {
    func doneButtonTapped(for newFood: String)
    {
        print(newFood)
        print(mealTapped)
        guard let mealTapped = mealTapped, let date = dateSelected else {
            return
        }
        if newFood != "" {
            fullPlan.plan[date]?.day[mealTapped]?.append(newFood)
            tableView.reloadData()
        }
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

