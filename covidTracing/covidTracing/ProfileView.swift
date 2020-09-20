//
//  ProfileView.swift
//  covidTracing
//
//  Created by Akshay Talkad on 9/19/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import UIKit

class ProfileView: UIViewController {

    
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        // Do any additional setup after loading the view.
    }
    
    //To give attributes to buttons
    func configureButtons() {
        signOutButton.layer.cornerRadius = 0.1 * signOutButton.bounds.size.width
        signOutButton.clipsToBounds = true
        
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
