//
//  PortfolioData.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/19/23.
//

import Foundation

struct PortfolioRowData: Codable,Identifiable,Hashable {
    var id = UUID()
    var image: String?
    var name = ""
    var symbol: String?
    var totalValue = 0.0
    var percentage = 0.0
}
