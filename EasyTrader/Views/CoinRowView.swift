//
//  StockRowView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/3/22.
//

import SwiftUI
import Kingfisher

struct CoinRowView: View {
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
            
            //stock price
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(coin.currentPrice.toCurrency())")
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

