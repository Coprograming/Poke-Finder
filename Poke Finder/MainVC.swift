//
//  MainVC.swift
//  Poke Finder
//
//  Created by Kasey Schlaudt on 8/4/16.
//  Copyright © 2016 coprograming.com. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MainVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        map.userTrackingMode = MKUserTrackingMode.follow
        
        let geofireRef = FIRDatabase.database().reference()
        let geoFire = GeoFire(firebaseRef: geofireRef)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            map.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate , 2000, 2000)
        
        map.setRegion(coordinateRegion, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "ash")
        }
        return annotationView
    }
    
    func createSighting(forlocation location: CLLocation, withPokemon pokeId: Int){
        
        geoFire.setLocation(location, forKey: "\(pokeId)")
        
    }
    
    func showSightingsOnMap(location: CLLocation){
        let circleQuery = geoFire!.query(at: location, withRadius: 2.5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            if let key = key, let location = location {
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.map.addAnnotation(anno)
            }
        })
    }
    
    @IBAction func pokeBallPressed(_ sender: AnyObject) {
        let loc = CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        
        let rand = arc4random_uniform(151) + 1
        createSighting(forlocation: loc, withPokemon: Int(rand))
    }
}















