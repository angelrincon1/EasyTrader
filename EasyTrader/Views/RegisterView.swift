//
//  RegisterView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 11/8/22.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.presentationMode) var mode

    @State private var emailTextField: String = ""
    @State private var usernameTextField: String = ""
    @State private var nameTextField: String = ""
    @State private var passwordTextField: String = ""
    @State private var passwordVerTextField: String = ""
    
    @State private var authSuccess: Bool = false
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
                            
                            CustomInputField(imageName: "person", placeholderText: "Username", secure: false, text: $usernameTextField)
                            
                            CustomInputField(imageName: "person", placeholderText: "Full name", secure: false, text: $nameTextField)
                            
                            CustomInputField(imageName: "lock", placeholderText: "Password", secure: true, text: $passwordTextField)
                            
                            CustomInputField(imageName: "lock", placeholderText: "Confirm password", secure: true, text: $passwordVerTextField)
                            
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Button {
                            
                            if passwordTextField == passwordVerTextField {
                                
                                viewModel.register(withEmail: emailTextField, password: passwordTextField, fullname: nameTextField, username: usernameTextField)
                                
                                //ADD NOTIFICATION IF REGISTERING FAILS,
                                //MAYBE A FIELD IS ALREADY IN USE
                                
                            }
                            else {
                                errorDescription = "Passwords don't match."
                                showErrorAlert = true
                            }
                            
                        } label: {
                            Text("Register")
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
                                .background(.black)
                                .clipShape(Capsule())
                                .shadow(color: .gray.opacity(0.6), radius: 10)
                        }
                        .padding(.top, UIScreen.main.bounds.height * 0.12)
                                                
                    }
                    
                }
                //end of scrollView
                
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertText),
                      dismissButton: .default(Text("Dismiss"))
                )
            }
            .navigationBarBackButtonHidden()
            .background(Color("backgroundColor"))
            
        }
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
