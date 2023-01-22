//
//  ProfileView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/3/22.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @State var editedName: String = ""
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var AViewModel: AuthViewModel
    
    var body: some View {
        
        if let user = AViewModel.currentUser {
            ZStack {
                
                VStack {
                    
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
                    
                    Image("userIcon")
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                    
                    List() {
                        
                        //name
                        HStack {
                            Text("Name")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(user.fullname)")
                                .font(.subheadline)
                        }
                        .listRowBackground(Color("portfolioBackground"))
                        
                        //username
                        HStack {
                            Text("Username")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(user.username)")
                                .font(.subheadline)
                        }
                        .listRowBackground(Color("portfolioBackground"))
                        
                        //birthdate
                        HStack {
                            Text("Email")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(user.email)")
                                .font(.subheadline)
                        }
                        .listRowBackground(Color("portfolioBackground"))
                        
                        //users cash
                        HStack {
                            Text("Cash")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(user.cash.toCurrency())")
                                .font(.subheadline)
                        }
                        .listRowBackground(Color("portfolioBackground"))

                    }
                    .shadow(color: .gray.opacity(0.6), radius: 5)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, -10)

                    Spacer()
                    
                    //Add cash for user button
                    VStack {
                        Text("Need more cash?")
                            .font(.footnote)
                        Button {
                            //Add extra 10000 for user
                            let newBalance = AViewModel.currentUser!.cash + 10000
                            Firestore.firestore().collection("users")
                                .document((AViewModel.currentUser?.id)!).updateData(["cash":newBalance])
                            AViewModel.fetchUser()
                        } label: {
                            Text("Add more funds")
                                .foregroundColor(Color.white)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.06)
                        .background(.black)
                        .clipShape(Capsule())
                        .shadow(color: .gray.opacity(0.6), radius: 10)

                    }
                    .padding(.vertical, 10)
                    
                }
            }
            .background(Color("backgroundColor"))
            .navigationBarBackButtonHidden()
            .onAppear {
                AViewModel.fetchUser()
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
