//
//  BuyView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 11/13/22.
//

import SwiftUI

struct BuyView: View {
    @ObservedObject var viewModel = CoinService()
    @State private var showStockSheet = false
    @State var coinToShow: CoinModel?
    
    var body: some View {
        
        VStack {
            GeometryReader { _ in
                VStack {
                    //Search Bar
                    SearchBar(searchText: $viewModel.searchText, title: "Browse")
                        .onSubmit {
                            
                            if viewModel.searchText != "" {
                                viewModel.fetchRelatedCoins(searchText: viewModel.searchText.lowercased()) {
                                    viewModel.fetchRelatedCoinsInfo(relatedCoinsArray: viewModel.relatedCoinsArray) {
                                        viewModel.searchText = ""
                                        print("TASK COMPLETED")
                                        print(viewModel.coinArray)
                                    }
                                }
                            }
                        }
                    
                    HStack {
                        Text("Coin")
                        
                        Spacer()
                        
                        Text("Price")
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.horizontal)
                                        
                    //Suggested stocks to display
                    ScrollView {
                        VStack {
                            ForEach(viewModel.coinArray) { coin in
                                CoinRowView(coin: coin)
                                    .onTapGesture {
                                        self.coinToShow = coin
                                        print("COIN TO SHOW IS THE FOLLOWING \(coin)")
                                        
                                    }
                                    .sheet(item: self.$coinToShow) { coin in
                                        ModifySelectedStockView(amountOfCoins: 0, action: "Buy", coin: coin)
                                            .presentationDetents([
                                                .medium
                                            ])
                                            .padding(.top, 50)
                                            .padding(.bottom, 80)
                                            .edgesIgnoringSafeArea(.all)
                                    }
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .onAppear {
                viewModel.fetchCoinData()
            }
        }
        .background(Color("backgroundColor"))
    }
}

struct BuyView_Previews: PreviewProvider {
    static var previews: some View {
        BuyView()
    }
}

