//
//  transactionsViewController.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 20/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class TransactionsViewController: UIViewController{
    //MARK: - Data Variables
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Stocks.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    var stocksOwned = [Stocks]()
    var stockDataManager = StockDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StockOwnedCell", bundle: nil), forCellReuseIdentifier: "StockOwnedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stockDataManager.loadData() //CAN REMOVE ONCE DETAILSVC EDITS DATA AND LOADS IT.
        stocksOwned = StockDataManager.stocksOwned
        tableView.reloadData()
    }
}
    



extension TransactionsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockDataManager.stocksOwned.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockOwnedCell", for: indexPath) as! StockOwnedCell
        cell.delegate = self
        let stock = StockDataManager.stocksOwned[indexPath.item]
        let symbol = stock.symbol
        let quantity = String(format: "%.0f", stock.quantity)
        cell.symbolLabel.text = symbol
        cell.quantityLabel.text = "\(String(quantity)) units"
        cell.nameLabel.text = stock.title
        cell.valueLabel.text = "$\(String(format: "%0.f", stock.currentValue))"

        if let percentChange = stock.percentChange{
            let percentValue = Double(percentChange.dropLast())!
                if percentValue < 0.0{
                        cell.percentChangeLabel.textColor = #colorLiteral(red: 0.809532702, green: 0, blue: 0.1002618298, alpha: 1)
                }
            cell.percentChangeLabel.text = "\(String(format: "%.2f", percentValue))%"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

extension TransactionsViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.stockDataManager.deleteData(row: indexPath.item)
//                self.stocksOwned = StockDataManager.stocksOwned
            action.fulfill(with: .delete)
        }
        deleteAction.image = UIImage(named: "delete-icon")


        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

