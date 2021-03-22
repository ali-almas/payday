//
//  HTTPMethod.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case put
    case delete
}

extension HTTPMethod {
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}
