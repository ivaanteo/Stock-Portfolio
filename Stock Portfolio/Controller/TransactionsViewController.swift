//
//  transactionsViewController.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 20/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var stock = [StockResults]()
    var stockDetails = [StockDetails]()
    var stocksOwned: [StockModel] = [
        StockModel(name: "CapitalLand Mall Trust", symbol: "C38U.SI", quantity: 1000, entryPrice: 2.12),
        StockModel(name: "Ascendas Real Estate Investment Trust", symbol: "A17U.SI", quantity: 300, entryPrice: 3.17),
        StockModel(name: "Ascott Resident Trust", symbol: "HMN.SI", quantity: 1000, entryPrice: 1.05)
    ]
    
    

    var stockDataManager = StockDataManager()
    //var stockDataManager2 = StockDataManager2()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StockOwnedCell", bundle: nil), forCellReuseIdentifier: "StockOwnedCell")
        stockDataManager.delegate = self
//        stockDataManager2.delegate = self
        for stock in 0..<stocksOwned.count{
                self.stockDataManager.getData(symbol: self.stocksOwned[stock].symbol)
                //self.stockDataManager2.getData(input: self.stocksOwned[stock].symbol)
        }
        
    }
    
    
}
    



extension TransactionsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksOwned.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockOwnedCell", for: indexPath) as! StockOwnedCell
        let symbol = stocksOwned[indexPath.item].symbol
        let quantity = String(format: "%.0f", stocksOwned[indexPath.item].quantity)
            cell.symbolLabel.text = symbol
            cell.quantityLabel.text = "\(String(quantity)) units"
        cell.nameLabel.text = stocksOwned[indexPath.item].name
        if indexPath.item < self.stock.count{
            let percentChange = self.stock[indexPath.item].percentChange
            let percentValue = Double(percentChange.dropLast())
            cell.valueLabel.text = "$\(String(self.stock[indexPath.item].value))"
            cell.percentChangeLabel.text = percentChange
            if let safePercentValue = percentValue {
                if safePercentValue < 0.0{
                    cell.percentChangeLabel.textColor = #colorLiteral(red: 0.5299209952, green: 0.0005746562965, blue: 0.07113862783, alpha: 1)
            }
        }
        }
//        if indexPath.item < self.stockDetails.count{
//            cell.nameLabel.text = self.stockDetails[indexPath.item].name
//        }
        return cell
    }
    
    
}

extension TransactionsViewController: StockDataManagerDelegate{
    func failedWithError(error: Error) {
        print(error.localizedDescription)
    }
    func updatedStockData(_ stockDataManager: StockDataManager, stockData: StockData.GlobalQuote){
            let symbol = stockData.symbol
            let quantity = stockDataManager.getQuantity(list: stocksOwned, symbol: stockData.symbol)
            let value = stockDataManager.calculateValue(price: stockData.price, quantity: quantity)
            let stockResult = StockResults(symbol: symbol, value: value, percentChange: stockData.percentChange)
            stock.append(stockResult)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
}

//extension TransactionsViewController: StockDataManager2Delegate{
//
//    func failedWithError2(error: Error){
//        print(error.localizedDescription)
//    }
//    func updatedStockData2(_ stockDataManager: StockDataManager2, stockData: StockData.BestMatches) {
//        let stockDetail = StockDetails(name: stockData.name, currency: stockData.currency)
//        stockDetails.append(stockDetail)
//        print(stockDetail)
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//}
