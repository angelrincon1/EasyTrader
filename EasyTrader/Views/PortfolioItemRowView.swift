//
//  PortfolioItemRowView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/19/23.
//

import SwiftUI
import Kingfisher

struct PortfolioItemRowView: View {
    var rowData: PortfolioRowData
    var portValue: Double
    
    var body: some View {
        HStack {
            //image
            VStack {
                if rowData.name == "Cash" {
                    Image(systemName: rowData.image!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color("symbolsColor"))
                }
                else if rowData.name == "Other coins" {
                    Image("OtherCryptosImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
                else if rowData.name == "Portfolio" {
                    Image(systemName: rowData.image!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color("symbolsColor"))
                }
                else {
                    KFImage(URL(string: rowData.image ?? ""))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.orange)
                }
            }
            .padding(.leading, 10)
            .padding(.vertical, 5)
            
            //stock name
            VStack(alignment: .leading, spacing: 4) {
                Text(rowData.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                    .lineLimit(1)
                
                Text(rowData.symbol ?? "")
                    .font(.caption2)
                    .padding(.leading, 6)
            }
            .padding(.leading, 2)
            .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            //Total value of owned coin
            VStack(alignment: .center, spacing: 4) {
                Text("Total value")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Text("\(rowData.totalValue.toCurrency())")
                    .font(.caption2)
                    .padding(.leading, 6)
            }
            .padding(.leading, 2)
            
            Spacer()
            
            //percentage on portfolio
            VStack(alignment: .trailing, spacing: 4) {
                Text("Portfolio %")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Text((rowData.totalValue * 100 / portValue).toPercentString())
                    .font(.caption2)
                    .padding(.leading, 6)
            }
            .padding(.leading, 2)
            .padding(.trailing, 10)
            
        }
        .background(Color("portfolioRowBackground"))
        .cornerRadius(10)
//        .padding(.horizontal)
        .padding(.vertical, 4)
        
    }
}

//struct PortfolioItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PortfolioItemRowView()
//    }
//}
