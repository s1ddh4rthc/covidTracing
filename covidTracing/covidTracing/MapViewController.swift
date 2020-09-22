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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var red: Bool = false
    var yellow: Bool = false
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // didn't need the function for this
        mapButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
        mapButton.clipsToBounds = true
        conditionButton.layer.cornerRadius = 0.5 * conditionButton.bounds.size.width
        conditionButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width
        profileButton.clipsToBounds = true
    
    
        searchBar.delegate = self
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsTraffic = true
        mapView.showsCompass = false
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let coordinate = CLLocationCoordinate2D.init(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        let db = Firestore.firestore()
        db.collection("stores")
            .getDocuments() {
                (QuerySnapshot, Error) in
                for document in QuerySnapshot!.documents {
                    let safety = document.get("safety") as! String
                    if safety == "crowd" {
                        self.yellow = true
                        if let geo = document.get("geolocation") as? [Double] {
                            let mapAnnot = MKPointAnnotation()
                                    mapAnnot.title = document.get("name") as? String
                                    mapAnnot.subtitle = "\(mapAnnot.title) is busy."
                                    mapAnnot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                    self.mapView.addAnnotation(mapAnnot)
                        }
                    }
                    else if safety == "unsafe" {
                        self.red = true
                        if let geo = document.get("geolocation") as? [Double] {
                                let mapAnnot = MKPointAnnotation()
                                mapAnnot.title = document.get("name") as? String
                                mapAnnot.subtitle = "\(mapAnnot.title) has the virus."
                                mapAnnot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(mapAnnot)
                    }
                }
        }

    }
        }
        
    
    //To give attributes to buttons
    func configureButtons() {
        mapButton.layer.cornerRadius = 0.5 * mapButton.bounds.size.width
        mapButton.clipsToBounds = true
        conditionButton.layer.cornerRadius = 0.5 * conditionButton.bounds.size.width
        conditionButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width
        profileButton.clipsToBounds = true
        
        return
    }
        
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circlesView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        if (red) {
            circlesView.fillColor = UIColor.red
        }
        
        else {
            circlesView.fillColor = UIColor.yellow
        }
        
        circlesView.strokeColor = UIColor.black
        circlesView.alpha = 0.75
        circlesView.lineWidth = 2
        
        return circlesView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text!
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {
            (response, error) in
            
            if response == nil {
                
                print("error")
                
            } else {
                
                let latitude = response!.boundingRegion.center.latitude
                let longitude = response!.boundingRegion.center.longitude
                
                let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                self.mapView.setRegion(region, animated: true)
            }
            
        }
        
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

//func redZones() {
//
//       let db = Firestore.firestore()
//       db.collection("stores").whereField("safety", isEqualTo: "unsafe")
//                         .getDocuments() {
//                             (QuerySnapshot, Error) in
//                             self.red = true
//                             for document in QuerySnapshot!.documents {
//                                 if let geo = document.get("geolocation") as? [Double] {
//                                     let mapAnnot = MKPointAnnotation()
//                                     mapAnnot.title = document.get("name") as? String
//                                     mapAnnot.subtitle = "Location has the virus."
//                                     mapAnnot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
//                                     self.mapView.addAnnotation(mapAnnot)
//                                 }
//                             }
//                   }
//
//
//   func yellowZones() {
//
//
//       let db = Firestore.firestore()
//       db.collection("stores").whereField("safety", isEqualTo: "crowd")
//           .getDocuments() {
//               (QuerySnapshot, Error) in
//               self.yellow = true
//               for document in QuerySnapshot!.documents{
//                   if let geo = document.get("geolocation") as? [Double] {
//                       let mapAnnot = MKPointAnnotation()
//                       mapAnnot.title = document.get("name") as? String
//                       mapAnnot.subtitle = "Location is busy."
//                       mapAnnot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
//                       self.mapView.addAnnotation(mapAnnot)
//                   }
//               }
//       }
//   }
//
//
//



//    Got rid of this and stuff on map came up as red and yellow again
//    func fetchInfected() -> [[Int]] {
//        let db = Firestore.firestore()
//        var finGeo: [[Int]] = [[]]
//        db.collection("stores").whereField("infectedVisitorCount", isGreaterThan: 0)
//            .getDocuments() { (querySnapshot, error) in
//                for document in querySnapshot!.documents {
//                    if let geo = document.get("geolocation") as? [Int] {
//                        finGeo.append(geo)
//                    }
//                }
//        }
//        return finGeo
//    }
//
//    func fetchBusy() -> [[Int]] {
//        var finGeo: [[Int]] = [[]]
//        let db = Firestore.firestore()
//        db.collection("stores").whereField("visitorCount", isGreaterThan: 10)
//            .getDocuments() { (querySnapshot, error) in
//                for document in querySnapshot!.documents {
//                    if let geo = document.get("geolocation") as? [Int] {
//                        finGeo.append(geo)
//                    }
//                }
//        }
//        return finGeo
//    }
