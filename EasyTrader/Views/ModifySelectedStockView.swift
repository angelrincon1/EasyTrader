//
//  ModifySelectedStockView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/26/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Kingfisher

struct ModifySelectedStockView: View {
    @State var amountOfCoins = 0
    @State var action: String = ""
    @State var coin: CoinModel?
    @State var transactionTotal = 0.0
    @State var showAlert: Bool = false
    @State var alertText: String = ""
    
    @ObservedObject var viewModel = CoinService()
    @ObservedObject var AuthModel = AuthViewModel()
    
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
                
        VStack(alignment: .center, spacing: 40) {
            
            VStack {
                KFImage(URL(string: coin?.image ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                
                Text(coin?.name ?? "")
                    .font(.largeTitle)
                    .bold()
            }
            
            
            HStack {
                Text("Quantity:")
                    .font(.title)
                Text("\(amountOfCoins)")
                    .font(.title)
                
                
                Stepper(value: $amountOfCoins, in: 0 ... 10) {
                }
                .labelsHidden()
            }
            .padding(.horizontal, 60)
            
            
            VStack(spacing: 20) {
                
                HStack {
                    Text("Total:")
                        .font(.title)
                    Text((coin!.currentPrice * Double(amountOfCoins)).toCurrency())
                        .font(.title)
                }
                
                
                Button {
                    
                    if amountOfCoins > 0 {
                        
                        //MAKE SURE THAT COIN IS MODIFIED WITH THE CORRECT CURRENTPRICE
                        viewModel.fetchSearchableCoin(searchText: (coin?.name.lowercased())!) {
                            self.coin = viewModel.searchedCoin
                        }
                        
                        let transactionAmount = coin!.currentPrice * Double(amountOfCoins)
                        
                        //ADD MORE DATA SO API DOESN;T GET CALLED AS MUCH
                        let data = ["coinID": coin!.id,
                                    "qty": amountOfCoins,
                                    "date": Timestamp(date: Date())] as [String : Any]
                        
                        let transactionData = ["coinID": coin!.id,
                                               "coinName": coin!.name,
                                               "qty": amountOfCoins,
                                               "date": Timestamp(date: Date()),
                                               "price": coin!.currentPrice,
                                               "action": action,
                                               "image": coin!.image,
                                               "symbol": coin!.symbol] as [String : Any]
                        
                        Firestore.firestore().collection("users").document((AuthModel.currentUser?.id)!).collection("coins").whereField("coinID", isEqualTo: coin!.id).getDocuments { snapshot, error in
                            
                            if let e = error {
                                print(e.localizedDescription)
                            }
                            
                            guard let snapshot = snapshot else { return }
                            
                            //MAKE SURE DOCUMENT EXISTS
                            if snapshot.isEmpty {
                                print("DOCUMENT DOES NOT EXIST")
                                
                                //Verify that user complies with modification requirements
                                //(if buying, that user has enough funds, if selling, that user has enough stocks to sell)
                                
                                if action == "Buy" {
                                    //Verify that user has enough cash
                                    if AuthModel.currentUser!.cash > transactionAmount {
                                        //User has enough cash, add stock and substract the money
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).collection("coins").document().setData(data) { _ in
                                                print("STOCK ADDED TO DATABASE")
                                                //CHARGE USER FOR PURCHASE
                                                let newBalance = AuthModel.currentUser!.cash - transactionAmount
                                                Firestore.firestore().collection("users")
                                                    .document((AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                                                print("USER CHARGED")
                                            }
                                        //ADD TRANSACTION TO TRANSACTION HISTORY
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).collection("transactions").document().setData(transactionData) { _ in
                                                print("Transaction registered in database")
                                            }
                                        //Show Success Alert
                                        alertText = "Success! \n\n Your new coin was added to your portfolio."
                                        showAlert.toggle()
                                    }
                                    else {
                                        alertText = "Error \n\n Not enough funds to complete transaction."
                                        showAlert.toggle()
                                    }
                                }
                            }
                            else {
                                let ownedCoin = snapshot.documents.first?.data()
                                print("DOCUMENT EXISTS, IT'S THE FOLLOWING \(ownedCoin!["coinID"]!)")
                                
                                if action == "Buy" {
                                    //MAKE SURE USER HAS ENOUGH CASH TO BUY COINS
                                    if AuthModel.currentUser!.cash > transactionAmount {
                                        snapshot.documents.first?.reference.updateData(["qty":ownedCoin!["qty"]! as! Int + amountOfCoins])
                                        //CHARGE USER FOR PURCHASE
                                        let newBalance = AuthModel.currentUser!.cash - transactionAmount
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                                        print("USER CHARGED")
                                        //ADD TRANSACTION TO TRANSACTION HISTORY
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).collection("transactions").document().setData(transactionData) { _ in
                                                print("Transaction registered in database")
                                            }
                                        //Show Success Alert
                                        alertText = "Success! \n\n Coin added to your portfolio."
                                        showAlert.toggle()
                                    }
                                    else {
                                        alertText = "Error \n\n Not enough funds to complete transaction."
                                        showAlert.toggle()
                                    }
                                }
                                else {
                                    //MAKE SURE USER HAS ENOUGH COINS TO SELL
                                    let finalValue = ownedCoin!["qty"] as! Int - amountOfCoins
                                    let newBalance = AuthModel.currentUser!.cash + transactionAmount
                                    
                                    if finalValue < 0 {
                                        //Show Alert
                                        alertText = "Error \n\n Not enough coins owned."
                                        showAlert.toggle()
                                    }
                                    else if finalValue == 0 {
                                        //FUND USER FOR SALE
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                                        print("USER FUNDED")
                                        //ADD TRANSACTION TO TRANSACTION HISTORY
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).collection("transactions").document().setData(transactionData) { _ in
                                                print("Transaction registered in database")
                                            }
                                        //DELETE COIN DOCUMENT IF THERE ISN'T ANY LEFT
                                        snapshot.documents.first?.reference.delete()
                                        
                                        //Show success alert
                                        alertText = "Success! \n\n Coins sold."
                                        showAlert.toggle()
                                    }
                                    else {
                                        //FUND USER FOR SALE
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).updateData(["cash":newBalance])
                                        print("USER FUNDED")
                                        //SUBSTRACT COINS SOLD
                                        snapshot.documents.first?.reference.updateData(["qty":ownedCoin!["qty"]! as! Int - amountOfCoins])
                                        //ADD TRANSACTION TO TRANSACTION HISTORY
                                        Firestore.firestore().collection("users")
                                            .document((AuthModel.currentUser?.id)!).collection("transactions").document().setData(transactionData) { _ in
                                                print("Transaction registered in database")
                                            }
                                        
                                        //Show success alert
                                        alertText = "Success! \n\n Coins sold."
                                        showAlert.toggle()
                                    }
                                }
                            }
                        }
                    }
                    else {
                        //Show success alert
                        alertText = "Error \n\n Select a valid amount of coins."
                        showAlert.toggle()
                    }
                    
                } label: {
                    Text(action)
                        .foregroundColor(action == "Buy" ? .green : .red)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.06)
                        .background(.black)
                        .clipShape(Capsule())
                        .shadow(color: .gray.opacity(0.6), radius: 10)
                }
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertText),
                  dismissButton: .default(
                    Text("Dismiss"),
                    action: {
                        self.dismiss()
                    }
                  ))
        }
        .padding(.bottom, -30)
        
    }
}

//struct ModifySelectedStockView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifySelectedStockView()
//    }
//}
