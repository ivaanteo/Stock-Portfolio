////
////  StockDataManager2.swift
////  Stock Portfolio
////
////  Created by Ivan Teo on 22/6/20.
////  Copyright © 2020 Ivan Teo. All rights reserved.
////
//
//import Foundation
//
//struct StockDataManager2{
//    let baseUrl = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&apikey=IGI395LYYRIZAZEF"
//        var delegate: StockDataManager2Delegate?
//        func getData(input: String){
//            let urlString = "\(self.baseUrl)&keywords=\(input)"
//            accessURL(urlString)
//            return
//        }
//
//        func accessURL(_ urlString: String){
//
//            if let url = URL(string: urlString){
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                    if error == nil{
//                        if let safeData = data{
//                            if let stockData = self.parseJSON(safeData){
//                                self.delegate?.updatedStockData2(self, stockData: stockData)
//                            }
//                        }
//                    }
//                    else{
//                        self.delegate?.failedWithError2(error: error!)
//                    }
//            }
//                task.resume()
//        }
//            return
//    }
//
////    func parseJSON(_ stockData: Data) -> StockData.BestMatches?{
//            let decoder = JSONDecoder()
//            do {
//                let decodedData = try decoder.decode(StockData.self, from: stockData)
//                let stockData = StockData.BestMatches(name: decodedData.bestMatches[0].name, currency: decodedData.bestMatches[0].currency)
//                return stockData
//            } catch {
//                self.delegate?.failedWithError2(error: error)
//                return nil
//            }
//        }
//}
//protocol StockDataManager2Delegate{
//
//    func failedWithError2(error: Error)
//
////    func updatedStockData2(_ stockDataManager: StockDataManager2, stockData: StockData.BestMatches)
//}
