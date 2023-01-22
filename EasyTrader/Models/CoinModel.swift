//
//  CoinModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/20/22.
//

import Foundation

struct CoinModel: Codable, Identifiable, Hashable {
    let pid = UUID()
    let image: String
    let id: String
    let priceChangePercentage24HInCurrency: Double
    let currentPrice: Double
    let symbol: String
    let priceChangePercentage24H: Double
    let name: String
    let marketCap: Double
    let priceChange24H: Double
    var amountOwned: Int? = 0

    enum CodingKeys: String, CodingKey {
        case image, id
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentPrice = "current_price"
        case symbol
        case priceChangePercentage24H = "price_change_percentage_24h"
        case name
        case marketCap = "market_cap"
        case priceChange24H = "price_change_24h"
    }
}
