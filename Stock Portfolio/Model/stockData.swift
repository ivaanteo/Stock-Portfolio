//
//  stockData.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 21/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import Foundation

struct StockData: Decodable {
    let globalQuote: GlobalQuote
    //let bestMatches: [BestMatches]
    struct GlobalQuote: Decodable {
        let symbol: String
        let price: String
        let percentChange: String

        enum CodingKeys: String, CodingKey {
            case symbol = "01. symbol"
            case price = "05. price"
            case percentChange = "10. change percent"
        }
    }

//    struct BestMatches: Decodable{
//        let name: String
//        let currency: String
//            enum CodingKeys: String, CodingKey {
//                case name = "2. name"
//                case currency = "8. currency"
//            }
//        }

    enum CodingKeys: String, CodingKey {
    case globalQuote = "Global Quote"
    //case bestMatches = "bestMatches"
}
}
