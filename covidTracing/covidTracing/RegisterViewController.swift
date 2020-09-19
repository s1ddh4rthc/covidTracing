//
//  RegisterViewController.swift
//  covidTracing
//
//  Created by Prem Dhoot on 9/18/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        firstNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confPass = confirmPasswordTextField.text,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            password.count >= 6 else {
                return
        }
        
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            guard result != nil, error == nil else {
                print("error")
                return
            }
            
            DatabaseManager.shared.insertUser(with: CovidUser(firstName: firstName,
                                                              lastName: lastName,
                                                              email: email)) { (success) in
                                                                if !success {
                                                                    print("error")
                                                                }
            }
            
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureButtons()
    }
    
    func configureButtons(){
        createAccountButton.layer.cornerRadius = 0.05 * createAccountButton.bounds.size.width
        createAccountButton.clipsToBounds = true
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
