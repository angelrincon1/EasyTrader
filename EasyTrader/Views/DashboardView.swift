//
//  DashboardView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 11/13/22.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack{
                //Portfolio summary
                PortfolioView()
                    .environmentObject(viewModel)

            }
            
            HStack {
                OwnedCoinsView()
                    .environmentObject(viewModel)
            }
        }
        .background(Color("backgroundColor"))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
