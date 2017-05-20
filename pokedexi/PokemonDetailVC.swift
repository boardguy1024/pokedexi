//
//  PokemonDetailVC.swift
//  pokedexi
//
//  Created by park kyung suk on 2017/05/14.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var depenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
        let image = UIImage(named: "\(pokemon.pokeId)")
        mainImage.image = image
        currentEvoImage.image = image
        
        pokemon.downloadPokemonDetail { 
            
            //response成功しdownloadCompliteが実行されるのでここのクロージャが実行される。
            print("Did arrive here??")
            self.updateUI()
        }
    }

    func updateUI() {
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        depenseLabel.text = pokemon.defense
        baseAttackLabel.text = pokemon.attack
        typeLabel.text = pokemon.type
        discriptionLabel.text = pokemon.description
        
        if pokemon.nextEvoId == "" {
            
            evoLabel.text = "No Evolutions"
            // StackViewになっているのでこれを隠せばCurrentImageが真ん中に配置される。
            nextEvoImage.isHidden = true
        } else {
            nextEvoImage.isHidden = false
            nextEvoImage.image = UIImage(named: pokemon.nextEvoId)
            let str = "Next Evolution: \(pokemon.nextEvoName) - LVL:\(pokemon.nextEvoLevel)"
            evoLabel.text = str
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
