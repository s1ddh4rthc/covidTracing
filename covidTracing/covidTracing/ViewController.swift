//
//  ViewController.swift
//  covidTracing
//
//  Created by Siddharth on 9/18/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureButtons()
    }
    
    func configureButtons(){
        loginButton.layer.cornerRadius = 0.1 * loginButton.bounds.size.width
        loginButton.clipsToBounds = true
        createButton.layer.cornerRadius = 0.1 * createButton.bounds.size.width
        createButton.clipsToBounds = true
    }


}

