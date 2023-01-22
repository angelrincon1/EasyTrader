//
//  TransactionsView.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/8/23.
//

import SwiftUI
import FirebaseFirestore

struct TransactionsView: View {
    @ObservedObject var viewModel = UserViewModel()
    @ObservedObject var AuthModel = AuthViewModel()

    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Transactions")
                    .font(.headline)
                    .bold()
                
                Spacer()
                    
                Button {
                    Firestore.firestore().collection("users")
                        .document((AuthModel.currentUser?.id)!).collection("transactions").getDocuments { snap, error in
                            if let e = error {
                                print(e.localizedDescription)
                                return
                            }
                            
                            let docs = snap!.documents
                           
                            for doc in docs {
                                doc.reference.delete()
                            }
                            
                            viewModel.fetchUserTransactions()
                        }
                    
                } label: {
                    Text("Clear")
                }

            }
            .padding()
            
            HStack {
                Text("Coin")
                
                Spacer()
                
                Text("Summary (QTY)")
            }
            .foregroundColor(.gray)
            .font(.caption)
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    if viewModel.transactionsArray.isEmpty {
                        HStack {
                            Text("")
                            Spacer()
                            Text("NO TRANSACTIONS TO DISPLAY")
                            Spacer()
                            Text("")
                        }
                        .padding(.top, 100)
                        .fontWeight(.bold)
                    }
                    else {
                        ForEach(viewModel.transactionsArray, id: \.self) { coin in
                            TransactionRowView(coin: coin)
                            Divider()
                        }
                    }
                    
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .background(Color("backgroundColor"))
        .onAppear {
            viewModel.fetchUserTransactions()
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}
