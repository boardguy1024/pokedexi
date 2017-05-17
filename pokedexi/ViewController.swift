//
//  ViewController.swift
//  pokedexi
//
//  Created by park kyung suk on 2017/05/13.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UISearchBarDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicPlayer: AVAudioPlayer!
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var isSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate =  self
        collectionView.dataSource =  self
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        parsePokemonCSV()
        PlayBackGroundMusic()
    }
    
    func PlayBackGroundMusic() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            musicPlayer.prepareToPlay()
            //無限ループは -1
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokeId: pokeId)
                pokemons.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //MARK:- SearchBar Protocol Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //searchBarに文字がない場合にはsearchモードをfalse
        if searchBar.text == nil || searchBar.text == "" {
            isSearchMode = false
            view.endEditing(true)
        } else {
            isSearchMode = true
            
            //取得した文字を小文字に変更
            let lowerText = searchBar.text!.lowercased()
            
            filteredPokemons = pokemons.filter({ $0.name.contains(lowerText)})
        }
        //filteringされたインスタンスを表示させるため、collectionViewを再配置する
        collectionView.reloadData()
    }
    
    
    
    //MARK:- CollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            //searchMode時はfliteredPokemonで表示
            if isSearchMode {
                poke = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon: poke)
            } else {
                //全てのpokemonを表示
                cell.configureCell(pokemon: pokemons[indexPath.row])
            }
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon: Pokemon!
        if isSearchMode {
            pokemon = filteredPokemons[indexPath.row]
        } else {
           pokemon = pokemons[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // seeachMode時はfilterdPokemonのカウントを返す
        if isSearchMode {
            return filteredPokemons.count
        }
        return pokemons.count
    }
    
    //collectionviewのsection数を返す
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Cellサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                
                if let pokemon = sender as? Pokemon {
                    detailVC.pokemon = pokemon
                }
            }
        }
    }
    
    
    
    
    
    
}

