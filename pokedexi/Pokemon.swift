//
//  Pokemon.swift
//  pokedexi
//
//  Created by park kyung suk on 2017/05/13.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokeId: Int!
    
    var name: String {
        return _name
    }
    var pokeId: Int {
        return _pokeId
    }
    init(name: String , pokeId: Int) {
        self._name = name
        self._pokeId = pokeId
    }
    
}
