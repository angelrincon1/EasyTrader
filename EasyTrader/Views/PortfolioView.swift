//
//  PortfolioView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/19/23.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
            
            VStack(alignment: .leading, spacing: 0) {
                
                VStack {
                    Text("Portfolio")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                
                //Coins in portfolio
                VStack(spacing: -5) {
                    
                    if viewModel.portfolioData.isEmpty {
                        EmptyPortfolioRowView()
                    }
                    else if viewModel.portfolioData.count > 3 {
                        ForEach(viewModel.portfolioData.prefix(3)) { coin in
                            PortfolioItemRowView(rowData: coin, portValue: viewModel.portfolioValue)
                            
                        }
                        PortfolioItemRowView(rowData: PortfolioRowData(name: "Other coins", totalValue: viewModel.otherCoinsValue), portValue: viewModel.portfolioValue)
                    }
                    else {
                        ForEach(viewModel.portfolioData) { coin in
                            PortfolioItemRowView(rowData: coin, portValue: viewModel.portfolioValue)
                            
                        }
                    }
                    
                }
                .padding(.horizontal)
                
                
                //Users cash
                VStack {
                    PortfolioItemRowView(rowData: PortfolioRowData(image: "banknote", name: "Cash", totalValue: viewModel.userCash), portValue: viewModel.portfolioValue)
                }
                .padding(.horizontal)
                
                
                //Portfolio total value
                VStack {
                    PortfolioItemRowView(rowData: PortfolioRowData(image: "tray.full.fill", name: "Portfolio", totalValue: viewModel.portfolioValue), portValue: viewModel.portfolioValue)
                }
                .padding(.horizontal)
                
            }
            .padding(.vertical, 10)
            .background(Color("portfolioBackground"))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.6), radius: 5)
            .padding(.horizontal)
            .onAppear {
                viewModel.fetchPortfolioData()
            }
            
            
    }
}

//struct PortfolioView_Previews: PreviewProvider {
//    static var previews: some View {
//        PortfolioView()
//    }
//}
