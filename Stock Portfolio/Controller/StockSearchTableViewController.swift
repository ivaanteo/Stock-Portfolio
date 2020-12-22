//
//  StockSearchTableViewController.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 28/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit
import SwiftUI
import SwipeCellKit

class StockSearchTableViewController: UITableViewController {
    @ObservedObject var searchManager = SearchManager()

    var name: String?
    var symbol: String?
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchManager.delegate = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "StockSearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "stockSearchResultsCell")
        tableView.keyboardDismissMode = .onDrag
        searchBar.becomeFirstResponder()
    }

    


    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.stockDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockSearchResultsCell", for: indexPath) as! StockSearchResultTableViewCell
        cell.nameLabel.text = searchManager.stockDetails[indexPath.item].name
        cell.symbolLabel.text = searchManager.stockDetails[indexPath.item].symbol
        return cell
    }
    
    
//MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! StockSearchResultTableViewCell
        if let safeSymbol = currentCell.symbolLabel.text{
            self.symbol = safeSymbol}
        if let safeName = currentCell.nameLabel.text{
            self.name = safeName}
        performSegue(withIdentifier: "goToDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.name = self.name
            destinationVC.symbol = self.symbol
        }
    }

}




//MARK: - Search Bar Delegate Methods
extension StockSearchTableViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text{
            searchManager.fetchData(keyword: keyword)
        }
        searchBar.resignFirstResponder()
    }
}

//MARK: - Search Manager Delegate Methods
extension StockSearchTableViewController:SearchManagerDelegate{
    func updatedSearchResults() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


