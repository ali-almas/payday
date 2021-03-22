//
//  LoginEndpoint.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum AuthEndpoint {
    case login
    case registration
}

extension AuthEndpoint: EndpointDelegate {
    var url: String {
        switch self {
        case .login: return "\(base)/authenticate"
        case .registration: return "\(base)/customers"
        }
    }
}
