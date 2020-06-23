//
//  stockDataManager.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 21/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import Foundation

struct StockDataManager {
    let baseUrl = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE"
    var delegate: StockDataManagerDelegate?
    func getData(symbol: String){
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
                            self.delegate?.updatedStockData(self, stockData: stockData)
                        }
                    }
                }
                else{
                    self.delegate?.failedWithError(error: error!)
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



    func getQuantity(list: [StockModel], symbol: String) -> Double{
        var quantity: Double = 0
        for stock in 0..<list.count{
            if list[stock].symbol == symbol{
                quantity = list[stock].quantity
            }
        }
        return quantity
    }

    func calculateValue(price: String, quantity: Double ) -> Double{
        let value = Double(price)! * quantity
        return value
    }

}

protocol StockDataManagerDelegate{
    func failedWithError(error: Error)
    func updatedStockData(_ stockDataManager: StockDataManager, stockData: StockData.GlobalQuote)
}
