//
//  StackedContentView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/4/22.
//

import SwiftUI

struct StackedContentView: View {
    @State private var showSideMenu = false
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            MainTabView()
                .toolbar(showSideMenu ? .hidden : .visible)
            
            if showSideMenu {
                ZStack {
                    Color(.black)
                        .opacity(showSideMenu ? 0.25 : 0.0)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showSideMenu = false
                    }
                }
                .ignoresSafeArea()
            }
            
            SideMenuView()
                .frame(width: 300)
                .background(Color("sideMenuBackground"))
                .offset(x: showSideMenu ? 0 : -300)
                
        }
//        .navigationTitle("Home")
//        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSideMenu.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color("symbolsColor"))
                }
            }
        }
        .onAppear{
            showSideMenu = false
        }
        
    }
}

struct StackedContentView_Previews: PreviewProvider {
    static var previews: some View {
        StackedContentView()
    }
}
