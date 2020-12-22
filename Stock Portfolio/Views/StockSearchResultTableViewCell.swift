//
//  StockSearchResultTableViewCell.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 28/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit
import SwipeCellKit

class StockSearchResultTableViewCell : SwipeTableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
