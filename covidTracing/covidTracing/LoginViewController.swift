//
//  LoginViewController.swift
//  covidTracing
//
//  Created by Prem Dhoot on 9/18/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet var loginToAppButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureButtons()
    }
    func configureButtons(){
        loginToAppButton.layer.cornerRadius = 0.1 * loginToAppButton.bounds.size.width
        loginToAppButton.clipsToBounds = true
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty, !password.isEmpty else {
            
            return
            
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let authResult = result, error == nil else {
                print("error")
                return
            }
            print("login successful")
        }
        
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
