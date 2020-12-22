

import Foundation

class SearchManager:ObservableObject {

    @Published var stockDetails = [SearchData.bestMatches]()
    
    var delegate: SearchManagerDelegate?

    func fetchData(keyword: String){
        let baseUrl = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&apikey=\(StockDataManager.apikey)&keywords=\(keyword)"
        if let url = URL(string: "\(baseUrl)&"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    if let safeData = data{
                        do{
                            let results = try decoder.decode(SearchData.self, from: safeData)
                            DispatchQueue.main.async {
                                self.stockDetails = results.bestMatches
                                self.delegate?.updatedSearchResults()
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

protocol SearchManagerDelegate {
    func updatedSearchResults()
}
