//
//  EndpointDelegate.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol EndpointDelegate {
    var base: String { get }
    var url: String { get }
}

extension EndpointDelegate {
    var base: String {
        return "http://localhost:3000"
    }
}
