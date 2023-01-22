//
//  SideMenuRowView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/4/22.
//

import SwiftUI

struct SideMenuRowView: View {
    let viewModel: SideMenuViewModel
    
    var body: some View {
        
        HStack(spacing: 16) {
            Image(systemName: viewModel.imageName)
                .font(.headline)
            Text(viewModel.title)
                .font(.subheadline)
            
            Spacer()
        }
        .fontWeight(.bold)
        .foregroundColor(Color("symbolsColor"))
        .frame(height: 40)
        
    }
}

struct SideMenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuRowView(viewModel: .profile)
    }
}
