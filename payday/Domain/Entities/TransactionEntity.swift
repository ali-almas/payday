//
//  TransactionEntity.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

typealias Transactions = [TransactionEntity]

struct TransactionList: Codable {
    let transactions: [TransactionEntity]
}

struct TransactionEntity: Codable {
    let id, accountID: Int
    let amount, vendor, category: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case id
        case accountID = "account_id"
        case amount, vendor, category, date
    }
}

