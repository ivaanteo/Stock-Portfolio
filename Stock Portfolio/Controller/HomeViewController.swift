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
import CoreData

class HomeViewController: UIViewController{

    var stockDataManager = StockDataManager()
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
//MARK: - Chart Variables
    @IBOutlet weak var pieChartView: PieChartView!
    var actualData = [PieChartDataEntry]()
    var colors: [UIColor] = []
    var totalValue = 0.0
    var totalProfit = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView.delegate = self
        pieChartView.animate(yAxisDuration: 2.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        stockDataManager.loadData() // CAN SHIFT TO VIEWDIDLOAD ONCE DETAILSVC DONE
        updateData()
        totalValue = stockDataManager.getTotalValue()
        valueLabel.text = String(format: "%.2f", totalValue)
        totalProfit = stockDataManager.getTotalProfit()
        if totalProfit > 0.0{
            percentLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        else{
            percentLabel.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        percentLabel.text = String(format: "%.2f", totalProfit) + " SGD"
        let pieChartDataSet = setupChartData()
        setupPieChart()
        chartUpdateColor(dataSet: pieChartDataSet)
        DispatchQueue.main.async {  
            self.pieChartView.notifyDataSetChanged()
            self.pieChartView.invalidateIntrinsicContentSize()
        }
    }
   
    func updateData(){
        for stock in StockDataManager.stocksOwned{
            stockDataManager.getData(symbol: stock.symbol!)
        }
    }

    func chartUpdateColor(dataSet: PieChartDataSet){
//        for _ in 0..<actualData.count {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            self.colors.append(color)
//        }
        dataSet.colors = ChartColorTemplates.pastel()
    }

    func setupChartData() -> PieChartDataSet{
        actualData = []
        for stock in StockDataManager.stocksOwned{
            let newEntry = PieChartDataEntry(value: stock.currentValue, label: stock.symbol)
            actualData.append(newEntry)
        }
        let pieChartDataSet = PieChartDataSet(actualData)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        return pieChartDataSet
    }
    
    func setupPieChart(){
        pieChartView.holeColor = nil
        pieChartView.drawCenterTextEnabled = true
        pieChartView.usePercentValuesEnabled = true
        let chartAttribute = [NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 14.0)!]

        let chartAttrString = NSAttributedString(string: "Your holdings", attributes: chartAttribute)
        pieChartView.centerAttributedText = chartAttrString
    }
}

extension HomeViewController : ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(StockDataManager.stocksOwned[Int(highlight.x)].symbol)
    }



}
