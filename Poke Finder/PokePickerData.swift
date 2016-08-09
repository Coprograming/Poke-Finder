//
//  PokePickerData.swift
//  Poke Finder
//
//  Created by Kasey Schlaudt on 8/6/16.
//  Copyright © 2016 coprograming.com. All rights reserved.
//

import Foundation

class PokePickerData  {
    private var _pokerNum: Int!
    private var _trueorFalse: Bool!
    
    var trueOrFalse: Bool {
        get {
            return _trueorFalse
        } set {
            _trueorFalse = newValue
        }
    }
    
    var pokeNum: Int {
        get {
            return _pokerNum
        } set {
            _pokerNum = newValue
        }
    }
    
    init(pokeNum: Int) {
        self.pokeNum = _pokerNum
    }
}
