//
//  AuthError.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum AuthError: Error {
    case hasEmptyValue
    case incorrectEmailFormat
    case incorrectPasswordForamat
    case networkError(NetworkError)
}

extension AuthError {
    var localizedDescription: String {
        switch self {
        case .hasEmptyValue: return "Please, make sure that all of the fields are filled"
        case .incorrectEmailFormat: return "Email that you entered is not in the correct format. Please enter valid email"
        case .incorrectPasswordForamat: return "Password that you entered is not in the correct format. Please check password and make sure that it is at least 6 character long"
        case .networkError(let error): return error.localizedDescription
        }
    }
}
