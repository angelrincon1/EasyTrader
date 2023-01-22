//
//  ContentView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 11/8/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        Group {
            
            if viewModel.userSession == nil {
                MainView()
            }
            else {
                StackedContentView()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
