//
//  MapViewController.swift
//  covidTracing
//
//  Created by Akshay Talkad on 9/19/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var red: Bool = false
    var yellow: Bool = false
    
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }

        if let userLocation = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let coordinate = CLLocationCoordinate2D.init(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.title = "Current Location"
            annotation.coordinate.latitude = userLocation.latitude
            annotation.coordinate.longitude = userLocation.longitude
            mapView.addAnnotation(annotation)
        }

        self.locationManager = locationManager

        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        let db = Firestore.firestore()
        
        var circleArray: [MKCircle] = []
        
        // This is the code for the red zones.
        db.collection("stores").whereField("infectedVisitorCount", isGreaterThan: 0)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Whoops! There was an error pulling up the documents: \(error)")
                } else {
                    self.red = true
                    
                    for document in querySnapshot!.documents {
                        if let geo = document.get("geolocation") as? [Double]{
                            if let name = document.get("name") as? String{
                                print("infected: \(name)")
                                let annot = MKPointAnnotation()
                                annot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                annot.title = name
                                annot.subtitle = "Infected"
                                self.mapView.addAnnotation(annot)
                                let redCircle: MKCircle = MKCircle(center: CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1]), radius: CLLocationDistance(100))
                                circleArray.append(redCircle)
                                self.mapView.addOverlay(redCircle)
                            }
                        }
                        
                    }
                }
        }
        
        //This is the code to put yellow zones on the map.
        db.collection("stores").whereField("safety", isEqualTo: "crowd")
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Whoops! There was an error pulling up the documents: \(error)")
                } else {
                    self.yellow = true
                    for document in querySnapshot!.documents {
                        if let geo = document.get("geolocation") as? [Double]{
                            if let name = document.get("name") as? String{
                                print("Busy: \(name)")
                                let yellowDots = MKPointAnnotation()
                                yellowDots.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                yellowDots.title = name
                                yellowDots.subtitle = "Busy"
                                self.mapView.addAnnotation(yellowDots)
                                let yellowCircle: MKCircle = MKCircle(center: CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1]), radius: CLLocationDistance(100))
                                circleArray.append(yellowCircle)
                                self.mapView.addOverlay(yellowCircle)
                            }
                        }
                    }
                    
                }
                
        }
    }
    
    func fetchInfected() -> [[Int]] {
        var finGeo: [[Int]] = [[]]
        let db = Firestore.firestore()
        db.collection("stores").whereField("infectedVisitorCount", isGreaterThan: 0)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Whoops! There was an error pulling up the documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let geo = document.get("geolocation") as? [Int] {
                            finGeo.append(geo)
                        }
                    }
                }
        }
        return finGeo
    }
    
    func fetchBusy() -> [[Int]] {
        var finGeo: [[Int]] = [[]]
        let db = Firestore.firestore()
        db.collection("stores").whereField("visitorCount", isGreaterThan: 10)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Whoops! There was an error pulling up the documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let geo = document.get("geolocation") as? [Int] {
                            finGeo.append(geo)
                        }
                    }
                }
        }
        return finGeo
    }

}


extension MapViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}



