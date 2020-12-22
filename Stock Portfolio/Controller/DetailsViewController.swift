//
//  DetailsViewController.swift
//  Stock Portfolio
//
//  Created by Ivan Teo on 28/6/20.
//  Copyright © 2020 Ivan Teo. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var entryPriceTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    // DIRECTLY EDIT DATA IN STOCK DATA!
    var name: String?
    var symbol: String?

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var stockDataManager = StockDataManager()
    var stocksOwned = [Stocks]()


    @IBAction func addButtonPressed(_ sender: UIButton) {
        var owned:Bool = false
        if let safeQuantity = quantityTextField.text, let safePrice = entryPriceTextField.text{
            if let quantityDouble = Double(safeQuantity), let priceDouble = Double(safePrice){
                for stock in StockDataManager.stocksOwned{
                if self.symbol! == stock.symbol!{
                    stock.entryPrice = ((stock.entryPrice * stock.quantity) + (quantityDouble * priceDouble)) / (stock.quantity + quantityDouble)
                    stock.quantity += quantityDouble
                    owned = true
                }
            }
            if owned == false{
                let newStock = Stocks(context: context)
                newStock.title = self.name!
                newStock.symbol = self.symbol!
                newStock.quantity = quantityDouble
                newStock.entryPrice = priceDouble
                StockDataManager.stocksOwned.append(newStock)
            }
//                    stockDataManager.saveData()
                displayAlert(text: "Added to portfolio")
                self.dismiss(animated: true, completion: nil)
                stockDataManager.getData(symbol: self.symbol!)
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsLabel.text = "\(name!) (\(symbol!))"
        addButton.layer.cornerRadius = addButton.frame.size.height * 0.2
        cancelButton.layer.cornerRadius = addButton.frame.size.height * 0.2
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
//        loadData()
        quantityTextField.becomeFirstResponder()
    }

    func displayAlert(text: String){
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.dismiss(animated: true)
        }
    }

        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func saveData() -> Bool{
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
            return false
        }
        return true
    }

//    func loadData(){
//        let request: NSFetchRequest<Stocks> = Stocks.fetchRequest()
//        do{
//            stocksOwned = try context.fetch(request)
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
}

