//
//  ModifyCoinViewModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/15/23.
//

import SwiftUI

class ModifyCoinViewModel: ObservableObject {
    
    @ObservedObject var viewModel = CoinService()
    
    func fetchUpdatedCoin(with name: String, completion: @escaping (CoinModel) -> Void) {
        viewModel.fetchSearchableCoin(searchText: name) {
            completion(self.viewModel.searchedCoin!)
        }
    }
    
}
