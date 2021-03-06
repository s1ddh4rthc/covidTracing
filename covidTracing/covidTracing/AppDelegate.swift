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
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RadarDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var locDict: [String: Int] = [:]
    
    func didReceiveEvents(_ events: [RadarEvent], user: RadarUser) {
        
    }
    
    func didUpdateLocation(_ location: CLLocation, user: RadarUser) {
        
    }
    
    func didFail(status: RadarStatus) {
        
    }
    
    func didLog(message: String) {
        
    }
    
    var firstName = "", lastName = "", emailAddy = ""
    var latitude = 0.0, longitude = 0.0
    
    // Firebase connection from app to database on Google Cloud Firestore
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    //let email = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    
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
                print("Current Locations Visited: \(places)")
                for place in places!{
                    if self.locDict[place.name] != nil {
                        self.locDict[place.name]!+=1
                        
                        if(self.locDict[place.name] == 5) {
                            print("Final: \(place.name)")
                            Database.database().reference().child("premdhoot6-gmail-com").observeSingleEvent(of: .value) { (snapshot) in
                                
                                let value = snapshot.value as? NSDictionary
                                
                                self.firstName = value?["firstName"] as? String ?? ""
                                self.lastName = value?["lastName"] as? String ?? ""
                                self.emailAddy = value?["email"] as? String ?? ""
                                
                            }
                            //SEND DATA TO USER-SPECIFIC FIREBASE
                            DatabaseManager.shared.saveUserLocation(with: CovidUser(firstName: self.firstName, lastName: self.lastName, email: self.emailAddy)) { (success) in
                                if !success {
                                    print("error")
                                }
                                print("location success")
                            }
                            //SEND DATA TO LOCATION-SPECIFIC FIREBASE AND THEN INCREMENT
                            //self.sendToLocDb(place: place)
                        }
                    }
                    else{
                        // make a new entry in dictionary
                        print("New location: \(place.name)")
                        self.locDict[place.name] = 1
                    }
                }
            }
        }
    }
    
    
    func application(_application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Radar.initialize(publishableKey: "prj_test_pk_6ac0c3189de6d9849d46644d2ce54a7ae01156fb") //Radar API key
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        Radar.setDelegate(self)
        
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
