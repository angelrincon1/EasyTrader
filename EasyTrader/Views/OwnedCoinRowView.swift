//
//  OwnedCoinRowView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/7/23.
//

import SwiftUI
import Kingfisher

struct OwnedCoinRowView: View {
    let coin: CoinModel
    
    var body: some View {
        HStack {
            //image
            KFImage(URL(string: coin.image))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.orange)
            
            //stock name
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Text(coin.symbol)
                    .font(.caption)
                    .padding(.leading, 6)
            }
            .padding(.leading, 2)
            
            Spacer()
            
            //Total value of owned coin
            VStack(alignment: .trailing, spacing: 4) {
                Text("\((coin.currentPrice * Double(coin.amountOwned!)).toCurrency()) (\(coin.amountOwned!))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Text(coin.priceChangePercentage24H.toPercentString())
                    .font(.caption)
                    .padding(.leading, 6)
                    .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
            }
            .padding(.leading, 2)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        
    }
}

struct OwnedCoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        OwnedCoinRowView(coin: CoinModel(image: "", id: "bitcoin", priceChangePercentage24HInCurrency: 12.2, currentPrice: 12233.2, symbol: "btc", priceChangePercentage24H: 12.2, name: "bitcoin", marketCap: 12.2, priceChange24H: 12.2, amountOwned: 12))
    }
}
