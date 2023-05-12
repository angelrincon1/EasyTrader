//
//  LogInView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 11/8/22.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @Environment(\.presentationMode) var mode
        
    @State private var emailTextField: String = ""
    @State private var passwordTextField: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var errorDescription: String = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        GeometryReader { _ in
            
            NavigationStack {
                
                ScrollView(.vertical) {
                    
                    //backbutton
                    HStack {
                        Button() {
                            mode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                        }
                        .font(.title)
                        .foregroundColor(Color("symbolsColor"))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        
                        LogoView(textFont: 30)
                            .scaledToFit()
                            .frame(height: 200)
                        
                        VStack(spacing: 40) {
                            
                            CustomInputField(imageName: "envelope", placeholderText: "Email", secure: false, text: $emailTextField)
                            
                            CustomInputField(imageName: "lock", placeholderText: "Password", secure: true, text: $passwordTextField)
                            
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Spacer()
                        
                        Button {
                            
                            viewModel.logIn(withEmail: emailTextField, password: passwordTextField)
                            
                        } label: {
                            Text("Log In")
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
                                .background(.black)
                                .clipShape(Capsule())
                                .shadow(color: .gray.opacity(0.6), radius: 10)
                        }
                        .padding(.top, UIScreen.main.bounds.height * 0.36)
                        
                    }
                }
                //end of scroll view

            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertText),
                      dismissButton: .default(Text("Dismiss"))
                )
            }
            .navigationBarBackButtonHidden()
            .background(Color("backgroundColor"))
            //end of navStack
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
