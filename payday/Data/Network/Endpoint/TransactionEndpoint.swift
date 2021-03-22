//
//  TransactionEndpoint.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum TransactionEndpoint {
    case transactionList
}

extension TransactionEndpoint: EndpointDelegate {
    var url: String {
        return "\(base)/transactions"
    }
}
