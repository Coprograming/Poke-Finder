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
    // MARK: - @IBOutlets
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - @Properties
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    var pokeNumber: Int!
    var pokePicker: PokePicker!
    var data:  PokePickerData!
    
    
    // MARK: - Initilizer
    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        map.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    // MARK: - Functions
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
        
    // MARK: - @IBActions
    
    @IBAction func pokeBallPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "PokePicker", sender: nil)
        
    }
    
}















