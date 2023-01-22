//
//  SearchBar.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/19/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State var title: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.gray), Color("gradientColor")]), startPoint: .top, endPoint: .bottom)
                .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height)*0.25, alignment: .center)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                HStack {
                    Text(title)
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                        .padding(.top, -40)
                    Spacer()
                }
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        .font(.title)
                    TextField("Search...", text: $searchText)
                        .font(.title3)
                        .foregroundColor(Color("symbolsColor"))
                }
                .frame(width:  ( UIScreen.main.bounds.width)*0.85, height: 40, alignment: .leading)
                .padding(.leading, 20)
                .background(Color("searchBarColor"))
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.6), radius: 2)
                
            }
        }

    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
    }
}
