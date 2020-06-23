//
//  StockOwnedCell.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 21/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit

class StockOwnedCell: UITableViewCell {

    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
