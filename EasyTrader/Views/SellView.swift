//
//  SellView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 11/15/22.
//

import SwiftUI

struct SellView: View {
    @State private var coinToShow: CoinModel?

    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Select Stock to Sell")
                .font(.headline)
                .bold()
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
                            Text("NO OWNED COINS TO SELL")
                            Spacer()
                            Text("")
                        }
                        .padding(.top, 100)
                        .fontWeight(.bold)
                    }
                    else {
                        ForEach (viewModel.ownedCoinsArray.sorted(by: { coin, coin2 in
                            return (coin.currentPrice * Double(coin.amountOwned!)) > (coin2.currentPrice * Double(coin2.amountOwned!))
                        }), id: \.self) { coin in
                            OwnedCoinRowView(coin: coin).onTapGesture {
                                self.coinToShow = coin
                            }
                            .sheet(item: $coinToShow) { coin in
                                ModifySelectedStockView(amountOfCoins: 0, action: "Sell", coin: coin)
                                    .presentationDetents([
                                        .medium
                                    ])
                                    .padding(.top, 50)
                                    .padding(.bottom, 80)
                                    .edgesIgnoringSafeArea(.all)
                                    .onDisappear {
                                        viewModel.fetchUserCoins()
                                    }
                            }
                        }
                    }
                    
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .background(Color("backgroundColor"))
        .onAppear {
            viewModel.fetchUserCoins()
        }
    }
}

struct SellView_Previews: PreviewProvider {
    static var previews: some View {
        SellView()
    }
}
