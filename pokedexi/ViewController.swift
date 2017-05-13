//
//  ViewController.swift
//  pokedexi
//
//  Created by park kyung suk on 2017/05/13.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate =  self
        collectionView.dataSource =  self
        let charmender = Pokemon(name: "ヒトカゲ", pokeId: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PokeCell {
            
            let pokemon = Pokemon(name: "Pokemon", pokeId: indexPath.row)
            cell.configureCell(pokemon: pokemon)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    //collectionviewのsection数を返す
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Cellサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    

}

