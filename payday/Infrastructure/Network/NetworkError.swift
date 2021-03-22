//
//  NetworkError.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum NetworkError: Error, Equatable {
    case timeOut
    case badUrl
    case badParams
    case wrongCreditals
    case badParsing
    case internetConnection
    case corruptedData
    case unknown(URLError)
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .timeOut:
            return "Connection timed out"
        case .badUrl:
            return "Url is not allowed format"
        case .badParams:
            return "Your parameters are not correct"
        case .internetConnection:
            return "Please, check internet connection and try again"
        case .badParsing:
            return "Parsing is not correct"
        case .wrongCreditals:
            return "Creditals is wrong"
        case .corruptedData:
            return "Data seems to corruped"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
