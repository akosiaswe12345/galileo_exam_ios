//
//  CountryDetailsViewController.swift
//  Galileo
//
//  Created by Taison Digital on 3/15/21.
//

import UIKit
import SVGKit

class CountryDetailsViewController: UIViewController {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var capitalLabale: UILabel!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    
    var name          = ""
    var cioc          = ""
    var flag          = ""
    
    var capital       = ""
    var alphaCode     = ""
    var population    = 0
    
    var name1         = ""
    var cioc1         = ""
    var flag1         = ""
    
    var capital1      = ""
    var alphaCode1    = ""
    var population1   = 0
    var searchBool    = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayText()
        
    }
    
    func displayText(){
        
        if searchBool {
            
            countryLabel.text = "Country Name: \(name1)"
            capitalLabale.text = "Capital: \(capital1)"
            alphaLabel.text = "Alpha Code: \(alphaCode1)"
            populationLabel.text = "Population: \(population1)"
            if let url = URL(string: flag1){
                countryImage.downloadedsvg(from: url)
            }
           
        } else {
            countryLabel.text = "Country Name: \(name)"
            capitalLabale.text = "Capital: \(capital)"
            alphaLabel.text = "Alpha Code: \(alphaCode)"
            populationLabel.text = "Population: \(population)"
            if let url = URL(string: flag){
                countryImage.downloadedsvg(from: url)
            }
        }
        
     
   
    }
    



}
