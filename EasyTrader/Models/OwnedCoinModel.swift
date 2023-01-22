//
//  OwnedCoinModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 1/7/23.
//

import Foundation
import FirebaseFirestoreSwift

struct OwnedCoinModel: Identifiable, Codable, Hashable {
    @DocumentID var uid: String?
    let id: String
    let qty: Int
    var date: Date? = Date()
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd 'of' MMMM"
        return formatter.string(from: date ?? Date())
    }
    var transactionType: String? = ""
    var image: String? = ""
    var name: String? = ""
    var transactionPrice: Double? = 0
    var symbol: String? = ""
}
