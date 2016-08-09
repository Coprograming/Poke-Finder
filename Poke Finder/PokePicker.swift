//
//  Poke Picker.swift
//  Poke Finder
//
//  Created by Kasey Schlaudt on 8/6/16.
//  Copyright © 2016 coprograming.com. All rights reserved.
//

import UIKit

class PokePicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - @IBOutlets
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pokeImg: UIImageView!
    
    // MARK: - @Properties
    
    var num: Int!
    var mainVc: MainVC!
    
    //MARK: - Initilizers
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    // MARK: - @IBActions
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        leaveScreen()
    }
    
    @IBAction func addPressed(_ sender: AnyObject) {
        if num == nil {
            print("KC: num = nil")
        } else {
            let loc = CLLocation(latitude: mainVc.map.centerCoordinate.latitude, longitude: mainVc.map.centerCoordinate.longitude)
            mainVc.createSighting(forlocation: loc , withPokemon: Int(num))
            
        }
        leaveScreen()
    }
}
