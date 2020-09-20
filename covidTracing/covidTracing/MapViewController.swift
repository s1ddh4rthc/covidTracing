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
    
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var red: Bool = false
    var yellow: Bool = false
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureButtons()
        
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
                        if let geo = document.get("geolocation") as? [Double] {
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
                    print("hello")
                    self.red = false
                    for document in querySnapshot!.documents {
                        print(document.data())
                        if let geo = document.get("geolocation") as? [Double] {
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
                
                if(circleArray.count>0) {
                    let region = MKCoordinateRegion(center: circleArray[0].coordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
                    self.mapView.setRegion(region, animated: true)
                }
                
        }
    }
    
    //To give attributes to buttons
    func configureButtons(){
        mapButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
        mapButton.clipsToBounds = true
        conditionButton.layer.cornerRadius = 0.5 * conditionButton.bounds.size.width
        conditionButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width
        profileButton.clipsToBounds = true
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
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circlesView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        if (red) {
            circlesView.fillColor = UIColor.red
        } else {
            circlesView.fillColor = UIColor.yellow
        }
        
        circlesView.strokeColor = UIColor.black
        circlesView.alpha = 0.5
        circlesView.lineWidth = 1.5
        
        return circlesView
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



