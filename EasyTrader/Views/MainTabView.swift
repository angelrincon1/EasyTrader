//
//  MainTabView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/3/22.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            DashboardView()
                .onTapGesture {
                    self.selectedIndex = 0
                }
                .tabItem {
                    VStack{
                        Image(systemName: "house")
                        Text("Home")
                    }
                }.tag(0)
            
            BuyView()
                .onTapGesture {
                    self.selectedIndex = 1
                }
                .tabItem {
                    VStack{
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Buy")
                    }
                }.tag(1)
            
            SellView()
                .onTapGesture {
                    self.selectedIndex = 2
                }
                .tabItem {
                    VStack{
                        Image(systemName: "dollarsign")
                        Text("Sell")
                    }
                }.tag(2)
            
            TransactionsView()
                .onTapGesture {
                    self.selectedIndex = 3
                }
                .tabItem {
                    VStack{
                        Image(systemName: "doc.plaintext")
                        Text("Transactions")
                    }
                }.tag(3)
        }
        .navigationTitle("EasyTrader")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
