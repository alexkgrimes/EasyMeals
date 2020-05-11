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
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "Meal History"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)

        dates = planHistory.plan.keys.sorted()
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
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
}
