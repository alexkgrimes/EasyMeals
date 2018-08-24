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
        let foodListString = newFoodText + " (" + quantityText + ") "
        
        delegate?.doneButtonTapped(for: foodListString)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Keyboard Show/Hide
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !keyboardIsShowing {
            self.view.frame.origin.y -= Constants.keyboardHeight
            keyboardIsShowing = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardIsShowing {
            self.view.frame.origin.y += Constants.keyboardHeight
            keyboardIsShowing = false
        }
    }
}
