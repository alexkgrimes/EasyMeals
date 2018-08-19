//
//  AddItemViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 8/16/18.
//  Copyright © 2018 Alex Grimes. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var addItemTitle: UILabel!
    @IBOutlet weak var doneAddingButton: UIButton!
    
    private var keyboardIsShowing = false
    
    private enum Constants {
        static let keyboardHeight: CGFloat = 216.0
    }
    
    @IBAction func doneAddingButtonPressed(_ sender: UIButton) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !keyboardIsShowing {
                self.view.frame.origin.y -= Constants.keyboardHeight
                keyboardIsShowing = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardIsShowing {
                self.view.frame.origin.y += Constants.keyboardHeight
                keyboardIsShowing = false
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
