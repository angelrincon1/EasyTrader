//
//  CustomInputField.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/6/22.
//

import SwiftUI

struct CustomInputField: View {
    let imageName: String
    let placeholderText: String
    let secure: Bool
    @Binding var text: String
    
    var body: some View {
        
        VStack{
            HStack{
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("inputFieldBackground"))
                
                if secure {
                    SecureField(placeholderText, text: $text)
                }
                else {
                    TextField(placeholderText, text: $text)
                }
                
            }
            
            Divider()
                .background(Color("inputFieldBackground"))
        }
        
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputField(imageName: "envelope", placeholderText: "Email", secure: false, text: .constant(""))
    }
}
