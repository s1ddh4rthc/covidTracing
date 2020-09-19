//
//  AppDelegate.swift
//  covidTracing
//
//  Created by Siddharth on 9/18/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import UIKit
import Firebase
import RadarSDK
import FirebaseFirestore
import FirebaseAuth
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RadarDelegate {
    func didReceiveEvents(_ events: [RadarEvent], user: RadarUser) {
        <#code#>
    }
    
    func didUpdateLocation(_ location: CLLocation, user: RadarUser) {
        <#code#>
    }
    
    func didFail(status: RadarStatus) {
        <#code#>
    }
    
    func didLog(message: String) {
        <#code#>
    }
    

    var window: UIWindow?
    var locationManager: CLLocationManager
    var locDict: [String: Int] = [:]
    
    // Firebase connection from app to database on Google Cloud Firestore
    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
      return true
    }

    func didUpdateClientLocation(_ location: CLLocation, stopped: Bool, source: RadarLocationSource) {
        /*
         
         Insert summary here later.
         
         */
        
        
        Radar.searchPlaces(
          near: location,
          radius: 30, //Based off what we wrote in RadarTracking.swift
          chains: ["costco", "starbucks"], // These are just two examples of chains that we're using.
          categories: ["food-beverage", "shopping-retail"],
          groups: nil,
          limit: 10
        ) { (status, location, places) in
            if(status == .success && places != nil && places!.count>0){
                // This is where all of the places that have been identified with a user will go to the database.
                print("Current Report: \(places)")
                for place in places!{
                    if let val = self.locDict[place.name] {
                        self.locDict[place.name]!+=1
                        
                        if(self.locDict[place.name] == 5) {
                            print("Final: \(place.name)")
                            //SEND DATA TO USER-SPECIFIC FIREBASE
                            self.sendToUserDb(place: place)
                            //SEND DATA TO LOCATION-SPECIFIC FIREBASE AND THEN INCREMENT
                        }
                    }
                    else{
                        // make a new entry in dictionary
                        print("NEW PLACE: \(place.name)")
                        self.locDict[place.name] = 1
                    }
                }
            }
        }
    }
    
    func sendToUserDb(place: RadarPlace) {
        let db = Firestore.firestore()
        let mail = UserDefaults.standard.string(forKey: "email")
        let userRep = db.collection("users").document(mail!)
        
        userRep.getDocument { (document, error) in
            
        
        }
        
        
    }
    
    
    func application(_application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Radar.initialize(publishableKey: publishableKey)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

