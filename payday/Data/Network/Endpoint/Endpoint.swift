//
//  Endpoint.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum Endpoint {
    case auth(AuthEndpoint)
    case account(AccountEndpoint)
    case transaction(TransactionEndpoint)
}

extension Endpoint {
    var url: String {
        switch self {
        case .auth(let end): return end.url
        case .account(let end): return end.url
        case .transaction(let end): return end.url
        }
    }
}
