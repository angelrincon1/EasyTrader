//
//  StockService.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/19/22.
//

import Foundation
import Alamofire
import SwiftyJSON

struct StockService {
    
    var iexURL = ""
    let key = "pk_4989861e862045279f1de0cae5c6e803"
    
    func fetchStock() {
        
        let parameters : [String:String] = [
            "tocken" : self.key
        ]
        
        Alamofire.request(iexURL, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("got api info")
                print(response)
            }
        }
        
    }
    
    func fetchSuggestedStocks() {
        
    }
    
    mutating func setUrl(StockSymbol: String) {
        self.iexURL = "https://cloud.iexapis.com/stable/stock/\(StockSymbol)/quote?"
    }
    
}
