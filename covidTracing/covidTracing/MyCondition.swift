//
//  MyCondition.swift
//  covidTracing
//
//  Created by Akshay Talkad on 9/19/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import SwiftUI

class MyCondition: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var testedText: UITextView!
    @IBOutlet weak var nearbyHospitals: UIButton!
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        
        if switchButton.isOn {
            datePicker.backgroundColor = .darkGray
            datePicker.layer.cornerRadius = 0.05 * datePicker.bounds.size.width
            datePicker.clipsToBounds = true
            testedText.alpha = 1
        } else {
            datePicker.backgroundColor = .black
            testedText.alpha = 0
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.backgroundColor = .black
        testedText.alpha = 0
        nearbyHospitals.layer.cornerRadius = 0.05 * nearbyHospitals.bounds.size.width
        nearbyHospitals.clipsToBounds = true
    }
    
}


struct MyCondition_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
