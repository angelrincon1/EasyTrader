//
//  LogoView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/6/22.
//

import SwiftUI

struct LogoView: View {
    @State var textFont: CGFloat = 50
    
    var body: some View {
        
        VStack {
            
            HStack { Spacer() }
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .foregroundColor(.black)
//                .background(Color.black)
                    
            Text("EasyTrader")
                .font(.system(size: textFont))
                .fontWeight(.heavy)
                .padding(.top, -20)
            
        }
        .padding(.top, -30)
//        .background(Color.gray)
        
        
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
