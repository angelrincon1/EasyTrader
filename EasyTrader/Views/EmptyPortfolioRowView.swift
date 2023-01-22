//
//  EmptyPortfolioRowView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/20/23.
//

import SwiftUI

struct EmptyPortfolioRowView: View {
    var body: some View {
        HStack {
            
            VStack {
                
            }
            
            Spacer()
            
            //stock name
            VStack(alignment: .leading, spacing: 4) {
                Text("NO OWNED COINS TO DISPLAY")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                    .lineLimit(1)
                
            }
            .padding(.leading, 2)
            .frame(height: 24, alignment: .leading)
            
            Spacer()
            
            VStack {
                
            }
            
        }
        .frame(height: 32)
        .padding(.horizontal)
        .padding(.vertical, 4)
        
    }
}

struct EmptyPortfolioRowView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPortfolioRowView()
    }
}
