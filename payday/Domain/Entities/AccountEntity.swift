//
//  AccountEntity.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

typealias Accounts = [AccountEntity]

struct AccountList: Codable {
    let accounts: [AccountEntity]
}

struct AccountEntity: Codable {
    let id, customerID: Int
    let iban, type, dateCreated: String
    let active: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case iban, type
        case dateCreated = "date_created"
        case active
    }
}
