//
//  AccountEndpoint.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum AccountEndpoint {
    case accounts
}

extension AccountEndpoint: EndpointDelegate {
    var url: String {
        switch self {
        case .accounts: return "\(base)/accounts"
        }
    }
}
