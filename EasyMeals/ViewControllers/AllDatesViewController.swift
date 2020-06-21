//
//  AllDatesViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 5/10/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit
import Firebase

class AllDatesViewController: UIViewController {
    
    var dates: [Date] = []
    var fullPlan: FullPlan
    var planHistory: PlanHistory
    
    // let orange = UIColor(red: 255.0 / 255.0, green: 149.0 / 255.0, blue: 0, alpha: 1.0)
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let emptyHistoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Your history is empty!"
        label.font = label.font.withSize(20)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startTrackingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Start tracking your meals and check back later to view your past meals"
        label.font = label.font.withSize(16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Meal History"
        label.textColor = .black
        label.font = .systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(fullPlan: FullPlan) {
        self.fullPlan = fullPlan
        self.planHistory = PlanHistory(fullPlan: fullPlan)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.topItem?.title = "Meal History"
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "⨉", style: .plain, target: self, action: #selector(dismissView))
        

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: "cell")
        
        dates = planHistory.plan.keys.sorted().reversed()
        
        if dates.isEmpty {
            
            view.addSubview(emptyHistoryLabel)
            view.addSubview(startTrackingLabel)
            
            NSLayoutConstraint.activate([
                emptyHistoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                emptyHistoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                emptyHistoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140)
            ])
            
            NSLayoutConstraint.activate([
                startTrackingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                startTrackingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                startTrackingLabel.topAnchor.constraint(equalTo: emptyHistoryLabel.bottomAnchor, constant: 16)
            ])
            
        } else {
            view.addSubview(headerLabel)
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                headerLabel.heightAnchor.constraint(equalToConstant: 50.0)
            ])

            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor)
            ])
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
    
    @objc func dismissView() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

extension AllDatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateTableViewCell
        cell.titleLabel.text = fullFormatter.string(from: dates[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlanHistoryViewController") as! PlanHistoryViewController
        viewController.dateString = fullFormatter.string(from: dates[indexPath.row])
        if let dayPlan = planHistory.plan[dates[indexPath.row]] {
            viewController.day = dayPlan
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
