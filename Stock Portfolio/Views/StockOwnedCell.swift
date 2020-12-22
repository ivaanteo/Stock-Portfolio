//
//  StockOwnedCell.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 21/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit
import SwipeCellKit
class StockOwnedCell : SwipeTableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var symbolLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!

    @IBOutlet weak var percentChangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    bgView.layer.cornerRadius = bgView.frame.size.height * 0.2
    
    }
    
}
