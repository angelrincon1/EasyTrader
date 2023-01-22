//
//  MainView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/12/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    VStack(alignment: .center) {
                        //Logo on top
                        LogoView()
                            .frame(height: 400)
                            .padding(.top, 50)
                        
                        Spacer()
                        
                        //Log in button
                        NavigationLink {
                            LogInView()
                        } label: {
                            Text("Log In")
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
                                .background(.black)
                                .clipShape(Capsule())
                                .padding(.top, 50)
                                .padding(.bottom)
                                .shadow(color: .gray.opacity(0.6), radius: 10)
                        }
                        
                        
                        //Register button
                        
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Register")
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
                                .background(.black)
                                .clipShape(Capsule())
                                .padding(.top, -10)
                                .padding(.bottom)
                                .shadow(color: .gray.opacity(0.6), radius: 10)
                        }
                        
                        
                    }
                }
                .background(Color("backgroundColor"))
                .frame(width: geo.size.width, height: geo.size.height)
                
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
