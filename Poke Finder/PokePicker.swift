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
    var pokemonName = [pokemon]
    
    /*private var _partyRock: PokeId!
    
    var partyRock: PokeId {
        get {
            return _partyRock
        } set {
            _partyRock = newValue
        }
    }*/
    
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
        let intValue = pokemon.index(of: value)
        let num = PokeId(pokeId: intValue)
        print("KC:num = \(num)")
        
    }
    
    func leaveScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destination as? MainVC {
            if let value = sender as? PokeId {
                destination.values = value
            }
        }
    }
    
    func switcher() -> Bool {
        func addPressed(_ sender: AnyObject) {
            performSegue(withIdentifier: "ShowMainVC", sender: num)
        }
        
        return true
    }


    // MARK: - @IBActions
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        leaveScreen()
        mainVc.selectedRow()
    }
    
    
}
