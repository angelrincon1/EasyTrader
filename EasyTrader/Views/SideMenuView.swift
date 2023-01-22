//
//  SideMenuView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/4/22.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var AViewModel: AuthViewModel
    
    var body: some View {
        
        if let user = AViewModel.currentUser {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Image("userIcon")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    
                    Text("Hello, \(user.fullname)")
                        .font(.headline)
                }
                .padding(.bottom, 30)
                
                ForEach(SideMenuViewModel.allCases, id: \.rawValue) { viewModel in
                    if viewModel == .profile {
                        
                        NavigationLink {
                            ProfileView()
                        } label: {
                            SideMenuRowView(viewModel: viewModel)
                        }
                    }
                    else if viewModel == .logOut {
                        
                        Button {
                            AViewModel.logOut()
                        } label: {
                            SideMenuRowView(viewModel: viewModel)
                        }
                        
                    }
                    else {
                        SideMenuRowView(viewModel: viewModel)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}


