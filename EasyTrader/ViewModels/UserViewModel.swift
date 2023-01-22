//
//  UserViewModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/7/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Alamofire
import SwiftyJSON

class UserViewModel: ObservableObject {
    @Published var ownedCoinsArray = [CoinModel]()
    @Published var transactionsArray = [OwnedCoinModel]()
    @Published var portfolioData = [PortfolioRowData]()
    @Published var portfolioValue = 0.0
    @Published var userCash = 0.0
    @Published var otherCoinsValue = 0.0
    
    @ObservedObject var AuthModel = AuthViewModel()
    
    //FETCH USERS OWNED COINS
    func fetchUserCoins() {
        
        self.ownedCoinsArray.removeAll()
        
        Firestore.firestore().collection("users").document((AuthModel.userSession?.uid)!).collection("coins").getDocuments { snap, error in
            guard let snap = snap else {return}
                        
            let userCoins = snap.documents.map { doc in
                OwnedCoinModel(id: doc["coinID"] as! String, qty: doc["qty"] as! Int)
            }
            
            let sortedUserCoins = userCoins.sorted { $0.id.replacingOccurrences(of: "-", with: "") < $1.id.replacingOccurrences(of: "-", with: "") }
            
            var coinIDsString: String = ""
                        
            for i in sortedUserCoins {
                if i == sortedUserCoins.last {
                    coinIDsString = String(coinIDsString + i.id)
                }
                else {
                    coinIDsString = String(coinIDsString + i.id + ",")
                }
            }
            
            let urlSearchString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(coinIDsString)&order=id_asc"
                        
            if coinIDsString.isEmpty {
                return
            }
            else {
                Alamofire.request(urlSearchString, method: .get).responseJSON { response in
                    if response.result.isSuccess {
                        let json = JSON(response.result.value!)
                        
                        var index = 0
                        for i in json {
                            self.ownedCoinsArray.append(CoinModel(image: i.1["image"].stringValue, id: i.1["id"].stringValue, priceChangePercentage24HInCurrency: i.1["price_change_percentage_24h_in_currency"].doubleValue, currentPrice: i.1["current_price"].doubleValue, symbol: i.1["symbol"].stringValue.uppercased(), priceChangePercentage24H: i.1["price_change_percentage_24h"].doubleValue, name: i.1["name"].stringValue, marketCap: i.1["market_cap"].doubleValue, priceChange24H: i.1["price_change_24h"].doubleValue, amountOwned: sortedUserCoins[index].qty))
                            
                            index += 1
                            
                        }
                    }
                }
            }
        }
    }
    
    //FETCH USER TRANSACTIONS
    func fetchUserTransactions() {
        self.transactionsArray.removeAll()
        
        Firestore.firestore().collection("users").document((AuthModel.userSession?.uid)!).collection("transactions").order(by: "date", descending: true).getDocuments { snap, error in
            guard let snap = snap else {return}
            
            self.transactionsArray = snap.documents.map { doc in
                OwnedCoinModel(id: doc["coinID"] as! String, qty: doc["qty"] as! Int, date: (doc["date"] as? Timestamp)?.dateValue(), transactionType: doc["action"] as? String, image: doc["image"] as? String, name: doc["coinName"] as? String, transactionPrice: doc["price"] as? Double)
            }
        }
    }
    
    //FETCH PORTFOLIO DATA
    func fetchPortfolioData() {
        
        self.portfolioData.removeAll()
        self.portfolioValue = 0.0
        self.otherCoinsValue = 0.0
        self.AuthModel.fetchUser()
        
        Firestore.firestore().collection("users").document((AuthModel.userSession?.uid)!).collection("coins").getDocuments { snap, error in
            guard let snap = snap else {return}
            
            let userCoins = snap.documents.map { doc in
                OwnedCoinModel(id: doc["coinID"] as! String, qty: doc["qty"] as! Int)
            }
            
            let sortedUserCoins = userCoins.sorted { $0.id.replacingOccurrences(of: "-", with: "") < $1.id.replacingOccurrences(of: "-", with: "") }
            
            var coinIDsString: String = ""
                        
            for i in sortedUserCoins {
                if i == sortedUserCoins.last {
                    coinIDsString = String(coinIDsString + i.id)
                }
                else {
                    coinIDsString = String(coinIDsString + i.id + ",")
                }
            }
            
            let urlSearchString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(coinIDsString)&order=id_asc"
                        
            if coinIDsString.isEmpty {
                    
                Firestore.firestore().collection("users").document((self.AuthModel.userSession?.uid)!).getDocument { snap, error in
                    guard let snap = snap else { return }
                    
                    self.userCash = snap.data()!["cash"]! as! Double
                    self.portfolioValue = self.userCash
                                        
                }
                
                return
            }
            else {
                Alamofire.request(urlSearchString, method: .get).responseJSON { response in
                    if response.result.isSuccess {
                        let json = JSON(response.result.value!)
                        
                        var index = 0
                        for i in json {
                            self.portfolioData.append(PortfolioRowData(image: i.1["image"].stringValue, name: i.1["name"].stringValue, symbol: i.1["symbol"].stringValue.uppercased(), totalValue: (i.1["current_price"].doubleValue * Double(sortedUserCoins[index].qty)), percentage: 12))
                                                        
                            index += 1
                        }
                        
                        self.portfolioData.sort(by: { $0.totalValue > $1.totalValue })
                        
                        for i in self.portfolioData {
                            self.portfolioValue += i.totalValue
                        }
                        
                        self.userCash = self.AuthModel.currentUser!.cash
                        
                        self.portfolioValue += self.userCash
                        
                        if self.portfolioData.count > 3 {
                            
                            self.otherCoinsValue = self.portfolioData[3...].reduce(0, { partialResult, value in
                                partialResult + value.totalValue
                            })
                        }
                    }
                }
            }
        }
    }
    
}
