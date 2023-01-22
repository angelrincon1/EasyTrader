//
//  OwnedStocksView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/19/22.
//

import SwiftUI
import FirebaseFirestore

struct OwnedCoinsView: View {
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Owned Coins")
                .font(.headline)
                .padding()
            
            HStack {
                Text("Coins")
                
                Spacer()
                
                Text("Total Value (QTY)")
            }
            .foregroundColor(.gray)
            .font(.caption)
            .padding(.horizontal)
            
            ScrollView {
                
                VStack {
                    if viewModel.ownedCoinsArray.isEmpty {
                        HStack {
                            Text("")
                            Spacer()
                            Text("NO OWNED COINS TO DISPLAY")
                            Spacer()
                            Text("")
                        }
                        .padding(.top, 100)
                        .fontWeight(.bold)
                    }
                    else {
                        ForEach (viewModel.ownedCoinsArray.sorted(by: { coin, coin2 in
                            return (coin.currentPrice * Double(coin.amountOwned!)) > (coin2.currentPrice * Double(coin2.amountOwned!))
                        }), id: \.pid) { coin in
                            OwnedCoinRowView(coin: coin)
                        }
                    }
                    
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .onAppear {
            viewModel.fetchUserCoins()
        }
        
    }
}

struct OwnedStocksView_Previews: PreviewProvider {
    static var previews: some View {
        OwnedCoinsView()
    }
}
