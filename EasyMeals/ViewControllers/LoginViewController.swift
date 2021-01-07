//
//  LoginViewController.swift
//  EasyMeals
//
//  Created by Alex Grimes on 3/29/19.
//  Copyright © 2019 Alex Grimes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        AuthController.signIn(output: self, email, password: password)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        AuthController.signUp(output: self, email, password: password)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else {
            return
        }
        
        AuthController.resetPassword(output: self, email: email)
    }
    
    var goodEmail = false
    var goodPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 14.0
        loginButton.layer.masksToBounds = true
        
        signupButton.layer.cornerRadius = 14.0
        signupButton.layer.masksToBounds = true
        
        navigationController?.navigationBar.isHidden = true
    }
}

extension LoginViewController: AuthControllerOutput {
    func signInFailed() {
        let alertController = UIAlertController(title: "Login Failed", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signInSuccess() {
        if let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "YourPlanViewController") as? YourPlanViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
        DataController.setUpDates()
    }
    
    func createUserFailed() {
        let alertController = UIAlertController(title: "Failed to Sign Up", message: "Please try again.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: AuthControllerReset {
    func resetSuccess() {
        let alertController = UIAlertController(title: "Success!", message: "A password reset has been sent to your email. Please check your inbox and follow the instructions to reset your password.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetFailed() {
        let alertController = UIAlertController(title: "Invalid Email", message: "Please enter an email associated with an account", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
