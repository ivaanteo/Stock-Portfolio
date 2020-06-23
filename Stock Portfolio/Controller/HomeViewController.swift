//
//  ViewController.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 20/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints
class HomeViewController: UIViewController, ChartViewDelegate{
    @IBOutlet weak var pieChartView: PieChartView!
    var dataEntry1 = PieChartDataEntry(value: 0)
    var dataEntry2 = PieChartDataEntry(value: 0)
    var actualData = [PieChartDataEntry(value: 1, label: "AAPL"), PieChartDataEntry(value: 3, label: "AMZN")]
    var colors: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let pieChartDataSet = PieChartDataSet(actualData)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.holeColor = nil
        chartUpdateColor(dataSet: pieChartDataSet)
        
        
    }
    
    func chartUpdateColor(dataSet: PieChartDataSet){
        for _ in 0..<actualData.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            self.colors.append(color)
            dataSet.colors = colors
        }
        
        
    }
}
