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
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        
        if switchButton.isOn {
            datePicker.backgroundColor = .white
        } else {
            datePicker.backgroundColor = .black
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.backgroundColor = .black
        
    }
    
}


struct MyCondition_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
