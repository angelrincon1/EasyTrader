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
//    @State var showAlert: Bool = false
//    @State var alertText: String = ""
    
    @ObservedObject var coinService = CoinService()
    @ObservedObject var viewModel = ModifyCoinViewModel()
    
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
                    
                    coinService.fetchSearchableCoin(searchText: coin!.id.lowercased()) { coin in
                        viewModel.executeTransaction(withCoin: coin, withAction: action, withQTY: amountOfCoins)
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertText),
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
