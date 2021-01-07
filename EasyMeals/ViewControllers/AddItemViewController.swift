//
//  AddItemViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/16/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

protocol AddFoodDelegate: class {
    func doneButtonTapped(for newFood: String)
}

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var addItemTitle: UILabel!
    @IBOutlet weak var doneAddingButton: UIButton!
    @IBOutlet weak var newFoodTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    weak var delegate: AddFoodDelegate?
    
    private var keyboardIsShowing = false
    private var newFoodText = ""
    private var quantityText = ""
    
    var mealName = ""
    
    private enum Constants {
        static let keyboardHeight: CGFloat = 216.0
    }
    
    @IBAction func doneAddingButtonPressed(_ sender: UIButton) {
        guard let newFoodText = newFoodTextField.text, let quantityText = quantityTextField.text else {
            return
        }
        
        var foodListString = ""
        if newFoodText == "" {
            foodListString = ""
        } else if quantityText == "" {
            foodListString = newFoodText
        } else {
            foodListString = newFoodText + " (" + quantityText + ")"
        }
        
        delegate?.doneButtonTapped(for: foodListString)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            } else {
                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            }
        }
        
        doneAddingButton.layer.cornerRadius = 14.0
        doneAddingButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
