//
//  stockDataManager.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 21/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit
import CoreData

class StockDataManager {
    //MARK: - Data Variables
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Stocks.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var stocksOwned = [Stocks]()

    let baseUrl = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE"
    var delegate: StockDataManagerDelegate?


    func getData(symbol: String){
        loadData()
        let urlString = "\(self.baseUrl)&apikey=\(StockDataManager.apikey)&symbol=\(symbol)"
        accessURL(urlString)
        return
    }
    
    func accessURL(_ urlString: String){
        if let url = URL(string: urlString){
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil{
                    if let safeData = data{
                        if let stockData = self.parseJSON(safeData){
                                let symbol = stockData.symbol
                            for stock in StockDataManager.stocksOwned{
                                    if symbol == stock.symbol!{
                                        if let safePrice = Double(stockData.price){
                                            stock.currentPrice = safePrice
                                        }
                                        stock.currentValue = self.calculateValue(price: stock.currentPrice, quantity: stock.quantity)
                                        stock.percentChange = stockData.percentChange
                                        self.saveData()
                                        }
                            }
                        }
                    }
                }
                else{
                    print(error!.localizedDescription)
                }
        }
            task.resume()
    }
        return
}

    func parseJSON(_ stockData: Data) -> StockData.GlobalQuote?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StockData.self, from: stockData)
            let stockData = StockData.GlobalQuote(symbol: decodedData.globalQuote.symbol, price: decodedData.globalQuote.price, percentChange: decodedData.globalQuote.percentChange)
            return stockData
        } catch {
            self.delegate?.failedWithError(error: error)
            return nil
        }
    }


    func getQuantity(list: [Stocks], symbol: String) -> Double{
        var quantity: Double = 0
        for stock in 0..<list.count{
            if list[stock].symbol == symbol{
                quantity = list[stock].quantity
            }
        }
        return quantity
    }

    func calculateValue(price: Double, quantity: Double ) -> Double{
        let value = price * quantity
        return value
    }

    func getTotalValue() -> Double{
        var totalValue = 0.0
        for stock in StockDataManager.stocksOwned{
                totalValue += stock.currentValue
            }
        return totalValue
    }
    
    func getTotalProfit() -> Double{
        var totalProfit = 0.0
        
        for stock in StockDataManager.stocksOwned{
            totalProfit += stock.currentValue - stock.entryPrice
        }
        return totalProfit
    }
    
    

    //MARK: - Core Data Functions
    func saveData(){
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }

    func loadData(){
        let request: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        do{
            StockDataManager.stocksOwned = try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteData(row: Int){
        context.delete(StockDataManager.stocksOwned[row])
        StockDataManager.stocksOwned.remove(at: row)
        saveData()
    }
    

}

protocol StockDataManagerDelegate{
    func failedWithError(error: Error)
    func updatedStockData(_ stockDataManager: StockDataManager, stockData: StockData.GlobalQuote)
}
