//
//  Pokemon.swift
//  pokedexi
//
//  Created by park kyung suk on 2017/05/13.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokeId: Int!
    private var _descripsion: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    private var _nextEvoName: String!
    private var _pokemonURL: String!

    var nextEvoName: String {
        if _nextEvoName == nil { _nextEvoName = "" }
        return _nextEvoName
    }
    var nextEvoText: String {
        if _nextEvoText == nil { _nextEvoText = "" }
        return _nextEvoText
    }
    var nextEvoId: String {
        if _nextEvoId == nil { _nextEvoId = "" }
        return _nextEvoId
    }
    var nextEvoLevel: String {
        if _nextEvoLevel == nil { _nextEvoLevel = "" }
        return _nextEvoLevel!
    }

    var description: String {
        if _descripsion == nil { _descripsion = "" }
        return _descripsion
    }
    var type: String {
        if _type == nil { _defense = "" }
        return _type
    }
    var defense: String {
        if _defense == nil { _defense = "" }
        return _defense
    }
    var height: String {
        if _height == nil { _height = "" }
        return _height
    }
    var weight: String {
        if _weight == nil { _weight = "" }
        return _weight
    }
    var attack: String {
        if _attack == nil { _attack = "" }
        return _attack
    }
    
    var name: String {
        return _name
    }
    var pokeId: Int {
        return _pokeId
    }
    init(name: String , pokeId: Int) {
        self._name = name
        self._pokeId = pokeId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokeId)"
    }
    
    func downloadPokemonDetail(complite: @escaping downloadComplite) {
        
        Alamofire.request(self._pokemonURL).responseJSON { (response) in
            
            if let dic = response.result.value as? Dictionary<String, AnyObject>{
            
                if let weight = dic["weight"] as? String {
                    self._weight = weight
                }
                if let height = dic["height"] as? String {
                    self._height = height
                }
                if let attack = dic["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dic["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dic["types"] as? [Dictionary<String,String>] , dic.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    // typesのcountが１以上の場合にはtypeの後ろにつけていく
                    if types.count > 1 {
                        
                        for index in 1..<types.count {
                            
                            if let name = types[index]["name"] {
                                
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                //Get description
                if let descriptions = dic["descriptions"] as? [Dictionary<String, String>] , descriptions.count > 0 {
                    
                    if let descURI = descriptions[0]["resource_uri"] {
                        
                        let reqURL = "\(URL_BASE)\(descURI)"
                        
                        Alamofire.request(reqURL).responseJSON(completionHandler: { (response) in
                            
                            if let dic = response.result.value as? Dictionary<String, AnyObject>{
                                
                                if let desc = dic["description"] as? String {
                                    
                                    //POKMONが含まれている場合、Pokemonに置き換え
                                    self._descripsion = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    print(self._descripsion)
                                }
                            }
                            // 非同期のため、ここでもresponseが完了したらcomplite()する
                            //ここでは{ }なかで呼び出す。（{}の外だとメモリから解放されnilになってしまうため）
                            complite()
                        })
                        
                    }
                } else {
                    self._descripsion = ""
                }
                
                if let evolutions = dic["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextName = evolutions[0]["to"] as? String {
                        
                        // megaが含まれるnextNameはデータをサポートしていないためfilteringする
                        if nextName.range(of: "mega") == nil {
                            self._nextEvoName = nextName
                            
                            if let url = evolutions[0]["resource_uri"] as? String {
                                
                                let str = url.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let id = str.replacingOccurrences(of: "/", with: "")
                                self._nextEvoId = id
                            }
                            if let levelExist = evolutions[0]["level"] {
                                if let level = levelExist as? Int {
                                    self._nextEvoLevel = "\(level)"
                                }
                                
                            } else {
                                self._nextEvoLevel = ""
                            }
                        }
                    }
                }
            }
            
            //response完了したのでcompliteクロージャを呼び出す。
            complite()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
