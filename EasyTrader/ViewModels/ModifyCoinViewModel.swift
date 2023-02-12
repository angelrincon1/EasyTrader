//
//  ModifyCoinViewModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/15/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ModifyCoinViewModel: ObservableObject {
    @Published var alertText: String = ""
    @Published var showAlert: Bool = false
    
    @ObservedObject var coinService = CoinService()
    @ObservedObject var AuthModel = AuthViewModel()
    
    func executeTransaction(withCoin transactionCoin: CoinModel, withAction action: String, withQTY coinQTY: Int) {
                
        if coinQTY > 0 {
            
            let transactionAmount = transactionCoin.currentPrice * Double(coinQTY)
            
            //Set the data to be stored
            let data = ["coinID": transactionCoin.id,
                        "qty": coinQTY,
                        "date": Timestamp(date: Date())] as [String : Any]
            
            let transactionData = ["coinID": transactionCoin.id,
                                   "coinName": transactionCoin.name,
                                   "qty": coinQTY,
                                   "date": Timestamp(date: Date()),
                                   "price": transactionCoin.currentPrice,
                                   "action": action,
                                   "image": transactionCoin.image,
                                   "symbol": transactionCoin.symbol] as [String : Any]
            
            Firestore.firestore().collection("users").document((AuthModel.currentUser?.id)!).collection("coins").whereField("coinID", isEqualTo: transactionCoin.id).getDocuments { snapshot, error in
                
                if let e = error {
                    print(e.localizedDescription)
                }
                
                guard let snapshot = snapshot else { return }
                
                //MAKE SURE DOCUMENT EXISTS
                if snapshot.isEmpty {
                    //Verify that user complies with modification requirements
                    //(if buying, that user has enough funds, if selling, that user has enough stocks to sell)
                    self.buyNewCoin(withData: data, transactionAmount: transactionAmount) { result in
                        if result {
                            self.registerTransaction(withData: transactionData)
                        }
                    }
                }
                else {
                    let ownedCoin = snapshot.documents.first?.data()
                    
                    self.modifyOwnedCoin(withCoin: ownedCoin!, withAction: action, withSnap: snapshot, transactionAmount: transactionAmount, coinQTY: coinQTY) { success in
                        if success {
                            self.registerTransaction(withData: transactionData)
                        }
                    }
                }
            }
        }
        else {
            //Show failure alert
            self.alertText = "Error \n\n Select a valid amount of coins."
            self.showAlert.toggle()
        }
    }
    
    func buyNewCoin(withData data: [String:Any], transactionAmount: Double, completion: @escaping (Bool) -> Void) {
        let success: Bool
        
        if AuthModel.currentUser!.cash > transactionAmount {
            //User has enough cash, add stock and substract the money
            Firestore.firestore().collection("users")
                .document((AuthModel.currentUser?.id)!).collection("coins").document().setData(data) { _ in
                    //CHARGE USER FOR PURCHASE
                    let newBalance = self.AuthModel.currentUser!.cash - transactionAmount
                    Firestore.firestore().collection("users")
                        .document((self.AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                }
            success = true
            //Show Success Alert
            self.alertText = "Success! \n\n Your new coin was added to your portfolio."
            self.showAlert.toggle()
        }
        else {
            success = false
            //Show Failure Alert
            self.alertText = "Error \n\n Not enough funds to complete transaction."
            self.showAlert.toggle()
        }
        completion(success)
    }
    
    func modifyOwnedCoin(withCoin ownedCoin: [String:Any], withAction action: String, withSnap snapshot: QuerySnapshot, transactionAmount: Double, coinQTY: Int, completion: @escaping (Bool) -> Void) {
        let success: Bool
        
        if action == "Buy" {
            //MAKE SURE USER HAS ENOUGH CASH TO BUY COINS
            if AuthModel.currentUser!.cash > transactionAmount {
                snapshot.documents.first?.reference.updateData(["qty":ownedCoin["qty"]! as! Int + coinQTY])
                //CHARGE USER FOR PURCHASE
                let newBalance = AuthModel.currentUser!.cash - transactionAmount
                Firestore.firestore().collection("users")
                    .document((AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                success = true
                //Show Success Alert
                self.alertText = "Success! \n\n Coin added to your portfolio."
                self.showAlert.toggle()
            }
            else {
                success = false
                //Show Failure Alert
                self.alertText = "Error \n\n Not enough funds to complete transaction."
                self.showAlert.toggle()
            }
        }
        else {
            //MAKE SURE USER HAS ENOUGH COINS TO SELL
            let finalValue = ownedCoin["qty"] as! Int - coinQTY
            let newBalance = AuthModel.currentUser!.cash + transactionAmount
            
            if finalValue < 0 {
                success = false
                
                //Show Alert
                self.alertText = "Error \n\n Not enough coins owned."
                self.showAlert.toggle()
            }
            else if finalValue == 0 {
                success = true
                
                //FUND USER FOR SALE
                Firestore.firestore().collection("users")
                    .document((AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                
                //DELETE COIN DOCUMENT IF THERE ISN'T ANY LEFT
                snapshot.documents.first?.reference.delete()
                
                //Show success alert
                self.alertText = "Success! \n\n Coins sold."
                self.showAlert.toggle()
            }
            else {
                success = true
                
                //FUND USER FOR SALE
                Firestore.firestore().collection("users")
                    .document((AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                //SUBSTRACT COINS SOLD
                snapshot.documents.first?.reference.updateData(["qty":ownedCoin["qty"]! as! Int - coinQTY])
                
                //Show success alert
                self.alertText = "Success! \n\n Coins sold."
                self.showAlert.toggle()
            }
        }
        completion(success)
    }
    
    func registerTransaction(withData transactionData: [String:Any]) {
        //ADD TRANSACTION TO TRANSACTION HISTORY
        Firestore.firestore().collection("users")
            .document((AuthModel.currentUser?.id)!).collection("transactions").document().setData(transactionData) { _ in
            }
    }
    
}
