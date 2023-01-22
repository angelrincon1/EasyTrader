//
//  TransactionRowView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/8/23.
//

import SwiftUI
import Kingfisher

struct TransactionRowView: View {
    let coin: OwnedCoinModel
    
    var body: some View {
        HStack {
            //image
            KFImage(URL(string: coin.image!))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.orange)
            
            //stock name
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Text(coin.symbol ?? "")
                    .font(.caption)
                    .padding(.leading, 6)
            }
            .padding(.leading, 2)
            
            Spacer()
            
            //coin price at transaction
            VStack(alignment: .trailing, spacing: 4) {
                Text("\((coin.transactionPrice! * Double(coin.qty)).toCurrency())")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Text("(\(coin.qty))")
                    .font(.caption)
                    .padding(.leading, 6)
                    .foregroundColor(.gray)
                
                Text(coin.transactionType ?? "")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(coin.transactionType == "Buy" ? Color.green:Color.red)
                
                Text(coin.dateString)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
            }
            .padding(.leading, 2)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        
    }
}

struct TransactionRowView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRowView(coin: OwnedCoinModel(id: "btc", qty: 2, date: Date(), transactionType: "Buy"))
    }
}
