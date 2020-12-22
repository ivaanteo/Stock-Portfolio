//
//  SearchData.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 28/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import Foundation

struct SearchData:Codable{
    let bestMatches: [bestMatches]
    struct bestMatches:Codable{
        let name: String
        let symbol: String
            enum CodingKeys: String, CodingKey {
                case name = "2. name"
                case symbol = "1. symbol"
            }
    }
}

