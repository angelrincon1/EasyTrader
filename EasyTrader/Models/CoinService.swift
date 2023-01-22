//
//  BuyViewModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/19/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class CoinService: ObservableObject {
    @Published var searchText = ""
    @Published var coinArray = [CoinModel]()
    @Published var searchedCoin: CoinModel?
    @Published var relatedCoinsArray = [String]()
    
    //fetch suggested stocks to be bought
    func fetchCoinData() {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=25&page=1&sparkline=true&price_change_percentage=24h"
        
        self.coinArray.removeAll()
        
        Alamofire.request(urlString, method: .get).responseJSON { response in
            if response.result.isSuccess {
                
                let jsonCoinData = JSON(response.result.value!)
                for i in jsonCoinData {
                    self.coinArray.append(CoinModel(image: i.1["image"].stringValue, id: i.1["id"].stringValue, priceChangePercentage24HInCurrency: i.1["price_change_percentage_24h_in_currency"].doubleValue, currentPrice: i.1["current_price"].doubleValue, symbol: i.1["symbol"].stringValue.uppercased(), priceChangePercentage24H: i.1["price_change_percentage_24h"].doubleValue, name: i.1["name"].stringValue, marketCap: i.1["market_cap"].doubleValue, priceChange24H: i.1["price_change_24h"].doubleValue))
                }
            }
        }
    }
    
    //fetch searchtext-related coins
    func fetchRelatedCoins(searchText: String, completion: @escaping () -> Void) {
        self.relatedCoinsArray.removeAll()
        let urlSearchString = "https://api.coingecko.com/api/v3/search?query=\(searchText)"
        
        Alamofire.request(urlSearchString, method: .get).responseJSON { response in
            if response.result.isSuccess {
                
                var json = JSON(response.result.value!)
                json = json["coins"]
                                
                for i in json {
                    self.relatedCoinsArray.append("\(i.1["id"].stringValue)")
                }
                
            }
            completion()
        }

        
        
    }
    
    //get all the info of the related coins
    func fetchRelatedCoinsInfo(relatedCoinsArray: [String], completion: @escaping () -> Void) {
        
        self.coinArray.removeAll()
        
        var coinIDsString: String = ""
        
        for i in relatedCoinsArray {
            if i == relatedCoinsArray.last {
                coinIDsString = String(coinIDsString + i)
            }
            else {
                coinIDsString = String(coinIDsString + i + ",")
            }
        }
        
        let urlSearchString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(coinIDsString)&order=market_cap_desc&per_page=100&page=1&sparkline=false"
        
        Alamofire.request(urlSearchString, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                
                for i in json {
                    self.coinArray.append(CoinModel(image: i.1["image"].stringValue, id: i.1["id"].stringValue, priceChangePercentage24HInCurrency: i.1["price_change_percentage_24h_in_currency"]["usd"].doubleValue, currentPrice: i.1["current_price"].doubleValue, symbol: i.1["symbol"].stringValue.uppercased(), priceChangePercentage24H: i.1["price_change_percentage_24h"].doubleValue, name: i.1["name"].stringValue, marketCap: i.1["market_cap"].doubleValue, priceChange24H: i.1["price_change_24h"].doubleValue))
                }
            }
        }
                        
        completion()
    }
    
    //fetch specific coin to update info when buying/selling
    func fetchSearchableCoin(searchText: String, completion: @escaping () -> Void) {
        let urlSearchString = "https://api.coingecko.com/api/v3/coins/\(searchText)?localization=false"
        
        Alamofire.request(urlSearchString, method: .get).responseJSON { response in
            if response.result.isSuccess {
                
                let json = JSON(response.result.value!)
                                
                self.searchedCoin = CoinModel(image: json["image"]["small"].stringValue, id: json["id"].stringValue, priceChangePercentage24HInCurrency: json["market_data"]["price_change_percentage_24h_in_currency"]["usd"].doubleValue, currentPrice: json["market_data"]["current_price"]["usd"].doubleValue, symbol: json["symbol"].stringValue.uppercased(), priceChangePercentage24H: json["market_data"]["price_change_percentage_24h"].doubleValue, name: json["name"].stringValue, marketCap: json["market_data"]["market_cap"]["usd"].doubleValue, priceChange24H: json["market_data"]["price_change_24h"].doubleValue)
                
                completion()
            }
        }
    }
    
}
