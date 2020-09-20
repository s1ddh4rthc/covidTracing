//
//  MyCondition.swift
//  covidTracing
//
//  Created by Akshay Talkad on 9/19/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import SwiftUI
import MapKit
import Foundation

class MyCondition: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var testedText: UITextView!
    @IBOutlet weak var nearbyHospitals: UIButton!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
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
    
    @IBAction func hospitalsButtonPressed(_ sender: Any) {
        
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7762, longitude: -121.9581)))
        mapItem.name = "Nearest Hospital"
        mapItem.openInMaps(launchOptions: options)
        
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
