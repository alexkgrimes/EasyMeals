//
//  ViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/12/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit
import Firebase

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
    
    let calendar = Calendar.current
    let orange = UIColor(red: 255.0 / 255.0, green: 149.0 / 255.0, blue: 0, alpha: 1.0)

    var mealTapped: String? = nil
    var dateSelected: Date? = nil
    
    var fullPlan = FullPlan()
    var planCurrent = PlanCurrent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = orange

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(backAction))
           
        guard let userId = AuthController.userId else {
            return
        }
        
        let datesRef = Database.database().reference(withPath: "users/\(userId)/dates")
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 4
        calendarFlowLayout.minimumInteritemSpacing = 4
        calendarFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 8)
        
        // Firebase
        datesRef.observe(.value, with: { snapshot in
            self.fullPlan = FullPlan(snapshot: snapshot)
            self.planCurrent = PlanCurrent(fullPlan: self.fullPlan)
            if self.dateSelected == nil {
                self.dateSelected = self.planCurrent.plan.keys.map { $0 }.sorted().first
            }
            self.updateTableView()
            self.calendarCollectionView.reloadData()
        })
    }
    
    @objc func backAction() {
        AuthController.signOut(output: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? AddItemViewController {
            controller.delegate = self
        }
    }
    
    func updateTableView() {
        tableView.reloadData()
        if (tableView.contentSize.height < tableView.frame.size.height) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
    }
}

// MARK: - TableViewDelegate

extension YourPlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let date = dateSelected, let plan = planCurrent.plan[date], let mealName = MealName(rawValue: mealNames[section]), let numRows = plan.day[mealName]?.count else {
            return 0
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealItemCell", for: indexPath) as! MealItemCell
        guard let date = dateSelected, let dayPlan = planCurrent.plan[date], let mealName = MealName(rawValue: mealNames[indexPath.section]), let foods = dayPlan.day[mealName] else {
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
        guard let date = dateSelected, let mealName = MealName(rawValue: mealNames[indexPath.section]), let mealItem = (planCurrent.plan[date]?.day[mealName]?[indexPath.row]) else {
            return
        }
        
        if editingStyle == .delete {
            guard let userId = AuthController.userId else {
                return
            }
            
            let datesRef = Database.database().reference(withPath: "users/\(userId)/dates")
            
            planCurrent.plan[date]?.day[mealName]!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            let dateString = formatter.string(from: date)
            let mealItemRef = datesRef.child("\(dateString)/\(mealNames[indexPath.section])/\(mealItem)")
            mealItemRef.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "mealHeaderCell") as! MealHeaderCell
        // let violet = hexStringToUIColor(hex: "6c71c4")

        header.mealNameLabel.text = mealNames[section]
        header.mealNameLabel.textColor = .white
        header.addItemButton.setTitleColor(.white, for: .normal)
        
        header.contentView.backgroundColor = orange
        header.contentView.layer.cornerRadius = Constants.cornerRadius
        header.contentView.layer.borderWidth = 0
        
        header.delegate = self
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

// MARK: - CollectionView Delegate

extension YourPlanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planCurrent.plan.keys.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreCalendarCell", for: indexPath) as! MoreCalendarCell
            let tapGesture = UITapGestureRecognizer(target: self, action: "pushMoreDatesView")
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tapGesture)
            cell.backgroundColor = .darkGray
            cell.moreLabel.textColor = .white
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 3.0
            cell.layer.cornerRadius = Constants.cornerRadius
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        
        let nsDate = planCurrent.plan.keys.map { $0 }.sorted()[indexPath.row - 1]
        let date = calendar.component(.day, from: nsDate)
        let weekday = calendar.component(.weekday, from: nsDate)
        let month = calendar.component(.month, from: nsDate)
        
        cell.dayLabel.text = calendarDays[weekday - 1]
        cell.dateLabel.text = calendarMonths[month - 1] + " \(date)"
        cell.dayLabel.textColor = .white
        cell.dateLabel.textColor = .white
        
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = Constants.cornerRadius
        
        if nsDate == dateSelected {
            cell.layer.borderColor = orange.cgColor
            cell.layer.borderWidth = 3.0
        } else {
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        dateSelected = planCurrent.plan.keys.map { $0 }.sorted()[indexPath.row - 1]
        updateTableView()
        collectionView.reloadData()
        
        cell?.layer.borderColor = orange.cgColor
        cell?.layer.borderWidth = 3.0
    }
}

// MARK: - AddFoodDelegate

extension YourPlanViewController: AddFoodDelegate {
    func doneButtonTapped(for newFood: String) {
        guard let mealTapped = mealTapped, let date = dateSelected, let userId = AuthController.userId else {
            return
        }
        if newFood != "" {
            
            let datesRef = Database.database().reference(withPath: "users/\(userId)/dates")
            let dateString = formatter.string(from: date)
            let mealRef = datesRef.child("\(dateString)/\(mealTapped)")
            
            let newFoodRef = mealRef.child(newFood)
            newFoodRef.setValue(newFood)
        
            updateTableView()
        }
    }
}

// MARK: - CreateMealDelegate

extension YourPlanViewController: CreateMealDelegate {
    func mealButtonPressed(for mealType: String) {
        mealTapped = mealType
    }
}

// MARK: - AuthControllerLogout

extension YourPlanViewController: AuthControllerLogout {
    func signOut() {
        navigationController?.popViewController(animated: true)
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

extension YourPlanViewController: MoreCalendarCellProtocol {
    @objc func pushMoreDatesView() {
        let viewController = AllDatesViewController(fullPlan: fullPlan)
        let modalNavigationController = UINavigationController(rootViewController: viewController)
        navigationController?.present(modalNavigationController, animated: true, completion: nil)
    }
}

