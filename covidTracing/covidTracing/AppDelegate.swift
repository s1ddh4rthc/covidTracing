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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RadarDelegate {

    var window: UIWindow?
    var locManager: CLLocationManager
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
          chains: nil,
          categories: ["food-beverage", "shopping-retail"],
          groups: nil,
          limit: 10
        ) { (status, location, places) in
            if(status == .success && places != nil && places!.count>0){
                print("Current Report: \(places)")
                
                // add all the detected places to location dictionary
                for place in places!{
                    
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
    
    
    
    func application(_application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

