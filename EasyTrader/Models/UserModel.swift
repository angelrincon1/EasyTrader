//
//  UserModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/13/22.
//

import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let username: String
    let fullname: String
    let email: String
    let cash: Double
}
