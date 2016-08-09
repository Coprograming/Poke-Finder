//
//  Poke Picker.swift
//  Poke Finder
//
//  Created by Kasey Schlaudt on 8/6/16.
//  Copyright © 2016 coprograming.com. All rights reserved.
//

import UIKit

class PokePicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pokeImg: UIImage!
    
    // MARK: - @Properties
    
    var pokeAnnotation: PokeAnnotation!
    var pokeNamePicked: Int!
    var geo: GeoFire
    var mainVc: MainVC!
    var data: PokePickerData!
    var num: Int!
    var isItTrue:Bool = false
    var pokeIndex: Int!
    
    var map = mainVC.map
    
    // MARK: - @Initilize Views
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        mainVc.map.delegate = mainVc
        
    }
    
    
    
    // MARK: - functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pokemon.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pokemon[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let value = pokemon[row]
        print("KC: \(value)")
        let number = pokemon.index(of: "\(value)")
        print("KC:num = \(number)")
        let sumnum = number
        if sumnum == nil {
            print("KC: num is nil")
        } else {
            num = number! + 1
        }
        
    }
    
    func leaveScreen() {
        dismiss(animated: true, completion: nil)
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
        let annoIdentifier = "Pokemon"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "ash")
        } else if let deqAnno = map.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: map.centerCoordinate.latitude , longitude: map.centerCoordinate.longitude)
        
        showSightingsOnMap(location: loc)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? PokeAnnotation {
            var place: MKPlacemark!
            if #available(iOS 10.0, *) {
                place = MKPlacemark(coordinate: anno.coordinate)
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }

// MARK: - @IBActions
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        leaveScreen()
    }
    
    @IBAction func addPressed(_ sender: AnyObject) {
        if num == nil {
            print("KC: num = nil")
        } else {
            let loc = CLLocation(latitude: mainVC.map.centerCoordinate.latitude, longitude: mainVc.map.centerCoordinate.longitude)
            createSighting(forlocation: loc , withPokemon: Int(num))

        }
        leaveScreen()
    }
}
