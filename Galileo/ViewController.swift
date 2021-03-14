//
//  ViewController.swift
//  Galileo
//
//  Created by Taison Digital on 3/11/21.
//

import UIKit
import Alamofire
import SDWebImage
import SVGKit

class ViewController: UIViewController {
    
    lazy var searchBar = UISearchBar(frame: .zero)

    @IBOutlet weak var tableView   : UITableView!
    @IBOutlet weak var viewHide    : UIView!
    @IBOutlet weak var searchLabel : UILabel!
    
    var name         = [String]()
    var cioc         = [String]()
    var flag         = [String]()
    
    var capital      = [String]()
    var alphaCode    = [String]()
    var population   = [Int]()
    
    
    var name1         = [String]()
    var cioc1         = [String]()
    var flag1         = [String]()
    
    var capital1      = [String]()
    var alphaCode1    = [String]()
    var population1   = [Int]()
    
    var test         = ["a", "b"]
    
    var index        = 0
    
    var searchBool   = false
    var selectedIndex = 0
    
    var indexPathRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBool   = false
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        setUpSearchBar()
        removeAlls()
        getStationDetail()
        tableView.reloadData()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        searchBool   = false
        removeAlls()
        getStationDetail()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if searchBool {
            if let countryDetails = segue.destination as? CountryDetailsViewController {
                print("CHECK index", indexPathRow)
                countryDetails.name1 = name1[indexPathRow]
                countryDetails.cioc1 = cioc1[indexPathRow]
                countryDetails.flag1 = flag1[indexPathRow]
                
                countryDetails.capital1 = capital1[indexPathRow]
                countryDetails.alphaCode1 = alphaCode1[indexPathRow]
                countryDetails.population1 = population1[indexPathRow]
                countryDetails.searchBool = searchBool
            }
        } else {
            if let countryDetails = segue.destination as? CountryDetailsViewController {
                countryDetails.name = name[indexPathRow]
                countryDetails.cioc = cioc[indexPathRow]
                countryDetails.flag = flag[indexPathRow]
                
                countryDetails.capital = capital[indexPathRow]
                countryDetails.alphaCode = alphaCode[indexPathRow]
                countryDetails.population = population[indexPathRow]
                countryDetails.searchBool = searchBool
            }
        }
        
       
    }
    
    
    private func setUpSearchBar() {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.searchBarStyle = .prominent
        searchBar.tintColor = UIColor.black
        navigationItem.titleView = searchBar
    }

}


// MARK: - tableview

extension ViewController : UITableViewDelegate, UITableViewDataSource{
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var counter = 0
    if searchBool {
        counter = cioc1.count
    } else {
        counter = cioc.count

    }
       return counter
    
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       if let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as? countryListTableViewCell {
           setUpCell(cell: cell, indexPath: indexPath)
           return cell
       }
       
       return UITableViewCell()
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
       return 1
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80.0
   }

   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       indexPathRow = indexPath.row
//       print("Selected index", selectedIndex)
       performSegue(withIdentifier: "details", sender: nil)
    
    
   }
   
    func setUpCell(cell: countryListTableViewCell, indexPath: IndexPath){
        
        if searchBool {
            cell.countryNameLabel.text = name[selectedIndex]
            cell.ciocLabel.text = cioc[selectedIndex]
            if let url = URL(string: flag[selectedIndex]){
                print("CHECK FLAG", url)
                cell.flagImage.downloadedsvg(from: url)
            }
        } else {
            cell.countryNameLabel.text = name[indexPath.row]
            cell.ciocLabel.text = cioc[indexPath.row]
            if let url = URL(string: flag[indexPath.row]){
                print("CHECK FLAG", url)
                cell.flagImage.downloadedsvg(from: url)
            }
        }
        
      
       
   }
}

// MARK - API CALLS

extension ViewController {
    
    private func getStationDetail() {
        
        guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else {
            return
        }
        
        AF.request(url).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                
                guard let jsonData = value as? [[String: Any]] else { return }
                
                print("TEST", jsonData)
                
                for JSON in jsonData {
                    self?.name.append(JSON["name"] as? String ?? "")
                    self?.cioc.append(JSON["cioc"] as? String ?? "")
                    self?.flag.append(JSON["flag"] as? String ?? "")
                    
                    self?.capital.append(JSON["capital"] as? String ?? "")
                    self?.alphaCode.append(JSON["alpha3Code"] as? String ?? "")
                    self?.population.append(JSON["population"] as? Int ?? 0)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("error", error)

            }
        }
    }
    
    func removeAlls() {
        name.removeAll()
        cioc.removeAll()
        flag.removeAll()
        
        capital.removeAll()
        alphaCode.removeAll()
        population.removeAll()
        
        name1.removeAll()
        cioc1.removeAll()
        flag1.removeAll()
        
        capital1.removeAll()
        alphaCode1.removeAll()
        population1.removeAll()
    }
    
}


// MARK : UI SEARCH BAR DELEGATE

extension ViewController : UISearchBarDelegate {
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
       if searchBar == self.searchBar {
           if searchBar.returnKeyType == .done {

           }
       }
   }
   
   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.tableVIew.reloadData()
//        self.reload()
       
       // hide clear button
       guard let firstSubview = searchBar.subviews.first else { return }
       firstSubview.subviews.forEach { ($0 as? UITextField)?.clearButtonMode = .never }
       searchBar.setShowsCancelButton(true, animated: true)
//        tableVIew.isHidden = true
//        emptyStateView.isHidden = true
   }
   
   func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       searchBar.setShowsCancelButton(false, animated: true)
       self.searchBar.endEditing(true)
//        self.tableVIew.reloadData()
//        self.reload()
   }
   
   func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
//        self.tableVIew.isHidden = false
//        self.tableVIew.reloadData()
//        self.reload()
       
       let typeCasteToStringFirst = searchBar.text as NSString?
       let newString = typeCasteToStringFirst?.replacingCharacters(in: range, with: text)
       let finalSearchString = newString ?? ""
    if finalSearchString.isEmpty {
        searchBool = false
        removeAlls()
        getStationDetail()
        tableView.reloadData()
    }else {
        self.loadSearchFriendList(withKeyword: finalSearchString.uppercased())
    }
    
//        self.currentSearchKey = finalSearchString.lowercased()
       return true
   }
   
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.setShowsCancelButton(false, animated: true)
//        self.emptyStateView.isHidden = true
//        self.tableVIew.isHidden = true
//        self.tableVIew.reloadData()
//        self.reload()
       self.searchBar.endEditing(true)
       self.searchBar.text = ""
   }
    
    func loadSearchFriendList(withKeyword: String){
        print("AX", withKeyword)
        if let index = self.cioc.firstIndex(of: withKeyword) {
            print(index) // Output: 4
//            removeAlls()
            
            name1.append(name[index])
            cioc1.append(cioc[index])
            flag1.append(flag[index])
            
            capital1.append(capital[index])
            alphaCode1.append(alphaCode[index])
            population1.append(population[index])
            
            selectedIndex = index
            searchBool = true
            tableView.reloadData()
            
            viewHide.isHidden = true
            
        }else {
            searchLabel.text = "No result found for \(withKeyword)"
            viewHide.isHidden = false
        }
    }
}



// MARK:

class countryListTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var ciocLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!

}

extension UIImageView {
func downloadedsvg(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
    contentMode = mode
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let receivedicon: SVGKImage = SVGKImage(data: data),
            let image = receivedicon.uiImage
            else { return }
        DispatchQueue.main.async() {
            self.image = image
        }
    }.resume()
}
}
